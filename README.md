# MiSTer Games Menu

Launch and browse games directly from the MiSTer menu. Games Menu scans your game collection, and creates a set of launchers in the menu which match your collection's folder layout.

Check out [MiSTer Extensions](https://github.com/wizzomafizzo/mrext) for other useful scripts!

## Installation

**WARNING: Due to a limitation with MiSTer's filesystem, a fully generated Games menu can take WAY more space than you think, even though the actual file size is very small. If you have a large collection of games (for example all the HTGDB packs) expect to use up to 10GB of space for this script with all systems selected. The space used reflects number of game files, not how big there are.**

Copy the [games_menu.sh](https://github.com/wizzomafizzo/MiSTer_GamesMenu/raw/main/gamesmenu.sh) file to your SD card's `Scripts` folder.

Run `games_menu` from the Scripts menu.

### Updates

Games Menu can be automatically updated with the downloader or update_all scripts. Add the following text to your `downloader.ini` file on the SD card:

```
[games_menu]
db_url = 'https://raw.githubusercontent.com/wizzomafizzo/MiSTer_GamesMenu/main/games_menu.json'
```

## Usage

Run `games_menu` from the Scripts menu, select the systems you want to be shown in the games menu, and then select the `Generate Menu` button.

Select a game from the newly created `Games` menu in the main MiSTer menu, and launch it as you would any other core or .mgl file.

The script needs to be re-run manually each time you add new games to your collection.

### Recent games

This script works great with MiSTer's built-in recents menu. Add `recents=1` to your main MiSTer .ini file, and open the recents menu with the `Select` button on your gamepad or the `` ` `` key on your keyboard.

MiSTer will display all recently run cores and .mgl files in this menu, which includes all games launched from the Games menu.

## Screenshots

![MiSTer menu](https://github.com/wizzomafizzo/MiSTer_GamesMenu/raw/main/images/games.jpeg)

![Manager menu](https://github.com/wizzomafizzo/MiSTer_GamesMenu/raw/main/images/menu.png)
