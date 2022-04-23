#!/usr/bin/env python

import os
import zipfile
import subprocess
import sys

GAMES_MENU_PATH = "/media/fat/_Games"
NAMES_FILE = "/media/fat/names.txt"

# (<games folder name>, <rbf>, (<file extensions>[], <delay>, <type>, <index>)[])
MGL_MAP = (
    ("ATARI2600", "_Console/Atari7800", (({".a78", ".a26", ".bin"}, 1, "f", 1),)),
    ("ATARI7800", "_Console/Atari7800", (({".a78", ".a26", ".bin"}, 1, "f", 1),)),
    ("AtariLynx", "_Console/AtariLynx", (({".lnx"}, 1, "f", 0),)),
    ("C64", "_Computer/C64", (({".prg", ".crt", ".reu", ".tap"}, 1, "f", 1),)),
    (
        "Coleco",
        "_Console/ColecoVision",
        (({".col", ".bin", ".rom", ".sg"}, 1, "f", 0),),
    ),
    ("GAMEBOY", "_Console/Gameboy", (({".gb", ".gbc"}, 1, "f", 1),)),
    ("GBA", "_Console/GBA", (({".gba"}, 1, "f", 0),)),
    ("Genesis", "_Console/Genesis", (({".bin", ".gen", ".md"}, 1, "f", 0),)),
    ("MegaCD", "_Console/MegaCD", (({".cue", ".chd"}, 1, "s", 0),)),
    (
        "NeoGeo",
        "_Console/NeoGeo",
        (({".neo", ".zip"}, 1, "f", 1), ({".iso", ".bin"}, 1, "s", 1)),
    ),
    ("NES", "_Console/NES", (({".nes", ".fds", ".nsf"}, 1, "f", 0),)),
    ("PSX", "_Console/PSX", (({".cue", ".chd"}, 1, "s", 1),)),
    ("SMS", "_Console/SMS", (({".sms", ".sg"}, 1, "f", 1), ({".gg"}, 1, "f", 2))),
    ("SNES", "_Console/SNES", (({".sfc", ".smc"}, 2, "f", 0),)),
    (
        "TGFX16",
        "_Console/TurboGrafx16",
        (
            ({".pce", ".bin"}, 1, "f", 0),
            ({".sgx"}, 1, "f", 1),
        ),
    ),
    (
        "TGFX16-CD",
        "_Console/TurboGrafx16",
        (({".cue", ".chd"}, 1, "s", 0),),
    ),
    ("VECTREX", "_Console/Vectrex", (({".ovr", ".vec", ".bin", ".rom"}, 1, "f", 1),)),
    ("WonderSwan", "_Console/WonderSwan", (({".wsc", ".ws"}, 1, "f", 1),)),
)

# source: https://mister-devel.github.io/MkDocs_MiSTer/cores/paths/#path-priority
GAMES_FOLDERS = (
    "/media/fat",
    "/media/usb0",
    "/media/usb1",
    "/media/usb2",
    "/media/usb3",
    "/media/usb4",
    "/media/usb5",
    "/media/fat/cifs",
)


def get_names_replacement(name: str):
    if not os.path.exists(NAMES_FILE):
        return name
    with open(NAMES_FILE, "r") as f:
        for entry in f:
            if ":" in entry:
                system, replacement = entry.split(":", maxsplit=1)
                if system.strip().lower() == name.lower():
                    return replacement.strip().replace("/", " & ")
    return name


# generate XML contents for MGL file
def generate_mgl(rbf, delay, type, index, path):
    mgl = '<mistergamedescription>\n\t<rbf>{}</rbf>\n\t<file delay="{}" type="{}" index="{}" path="../../../..{}"/>\n</mistergamedescription>'
    return mgl.format(rbf, delay, type, index, path)


def get_system(name: str):
    for system in MGL_MAP:
        if name.lower() == system[0].lower():
            return system
    return False


def match_system_file(system, filename):
    name, ext = os.path.splitext(filename)
    for type in system[2]:
        if ext.lower() in type[0]:
            return type


# {<system name> -> <full games path>[]}
def get_system_paths():
    systems = {}

    def add_system(name, folder):
        path = os.path.join(folder, name)
        if name in systems:
            systems[name].append(path)
        else:
            systems[name] = [path]

    def find_folders(path):
        if not os.path.exists(path) or not os.path.isdir(path):
            return False

        for folder in os.listdir(path):
            system = get_system(folder)
            if os.path.isdir(os.path.join(path, folder)) and system:
                add_system(system[0], path)

        return True

    for games_path in GAMES_FOLDERS:
        parent = find_folders(games_path)
        if not parent:
            break

        for subpath in os.listdir(games_path):
            if subpath.lower() == "games":
                find_folders(os.path.join(games_path, subpath))

    return systems


def type_has_zip(mgl_types):
    for type in mgl_types:
        if ".zip" in type[0]:
            return True
    return False


def to_mgl_args(system, match, full_path):
    return (
        system[1],
        match[1],
        match[2],
        match[3],
        full_path,
    )


# return a generator for all valid system roms
# (<system name>, <parent folder>, <filename>, <mgl args>, <sub path>)
def get_system_files(name, folder):
    system = get_system(name)
    for root, dirs, files in os.walk(folder):
        for filename in files:
            full_path = os.path.join(root, filename)
            if (
                filename.lower().endswith(".zip")
                and not type_has_zip(system[2])
                and zipfile.is_zipfile(full_path)
            ):
                # zip files
                zip = zipfile.ZipFile(full_path)
                for zip_filename in zip.namelist():
                    # only top level files
                    if os.path.sep not in zip_filename:
                        match = match_system_file(system, zip_filename)
                        if match is not None:
                            sub_path = root.replace(folder, "").lstrip(os.path.sep)
                            yield system[0], zip_filename, to_mgl_args(
                                system, match, os.path.join(full_path, zip_filename)
                            ), sub_path
            else:
                # regular files
                match = match_system_file(system, filename)
                if match is not None:
                    sub_path = root.replace(folder, "").lstrip(os.path.sep)
                    yield system[0], filename, to_mgl_args(
                        system, match, full_path
                    ), sub_path


# format menu folder names to show in menu core
def menu_format(sub_path):
    folders = sub_path.split(os.path.sep)
    return os.path.sep.join(["_" + x for x in folders])


def mgl_name(filename):
    name, ext = os.path.splitext(filename)
    return name + ".mgl"


def create_mgl_file(system_name, filename, mgl_args, sub_path):
    if sub_path == "":
        rel_path = system_name
    else:
        rel_path = os.path.join(system_name, sub_path)
    mgl_folder = os.path.join(GAMES_MENU_PATH, menu_format(rel_path))
    mgl_path = os.path.join(mgl_folder, mgl_name(filename))
    if not os.path.exists(mgl_folder):
        os.makedirs(mgl_folder)
    if not os.path.exists(mgl_path):
        with open(mgl_path, "w") as f:
            mgl = generate_mgl(*mgl_args)
            f.write(mgl)


def display_menu(system_paths):
    args = [
        "dialog",
        "--title",
        "Games Menu",
        "--cancel-label",
        "Exit",
        "--checklist",
        "Select systems to show in Games menu.",
        "20",
        "75",
        "20",
    ]

    for system in sorted(system_paths.keys(), key=str.lower):
        display_name = get_names_replacement(system)
        args.append(str(system))
        args.append(str(display_name))
        if os.path.exists(os.path.join(GAMES_MENU_PATH, "_" + display_name)):
            args.append("on")
        else:
            args.append("off")

    result = subprocess.run(args, stderr=subprocess.PIPE)

    button = result.returncode
    selection = result.stderr.decode()

    return button, selection


if __name__ == "__main__":
    system_paths = get_system_paths()
    button, selection = display_menu(system_paths)
    print("")

    if button == 0:
        systems = selection.split(" ")

        if len(systems) == 0 or systems[0] == "":
            sys.exit(0)

        for system in systems:
            folder_name = get_names_replacement(system)
            print("Scanning {} ({})...".format(system, folder_name), end="", flush=True)
            count = 0
            for folder in system_paths[system]:
                for file in get_system_files(system, folder):
                    create_mgl_file(folder_name, file[1], file[2], file[3])
                    if count >= 250:
                        print(".", end="", flush=True)
                        count = 0
                    else:
                        count += 1
            print("Done!", flush=True)

        # TODO: delete deselected systems
        # TODO: move up files in folders with only one item
        # TODO: cleanup mgl files with broken links

    sys.exit(0)
