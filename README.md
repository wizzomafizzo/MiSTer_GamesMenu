# MiSTer Games Menu

Launch and browse games directly from the MiSTer menu. Games Menu scans your game collection, and creates a set of launchers in the menu which match your collection's folder layout.

This script works well with the [Favorites](https://github.com/wizzomafizzo/MiSTer_Favorites) and [BGM](https://github.com/wizzomafizzo/MiSTer_BGM) scripts.

## Installation

Copy the [games_menu.sh](https://github.com/wizzomafizzo/MiSTer_GamesMenu/raw/main/games_menu.sh) file to your SD card's `Scripts` folder.

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
