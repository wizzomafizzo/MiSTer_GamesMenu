# MiSTer GamesMenu (archived)

Development moved to the main [mrext repository](https://github.com/wizzomafizzo/mrext#gamesmenu).

Current source and manual download: [`scripts/gamesmenu.sh`](https://github.com/wizzomafizzo/mrext/raw/main/scripts/gamesmenu.sh)

## Existing MiSTer Downloader installations

The standalone GamesMenu downloader database will no longer receive updates from this repository. Downloader configuration is not migrated automatically.

In `downloader.ini` on the SD card, remove the old GamesMenu entry:

```ini
[games_menu]
db_url = 'https://raw.githubusercontent.com/wizzomafizzo/MiSTer_GamesMenu/main/games_menu.json'
```

Replace it with the combined mrext database:

```ini
[mrext/all]
db_url = https://raw.githubusercontent.com/wizzomafizzo/mrext/main/releases/all.json
```

Then run `downloader` or `update` from the MiSTer Scripts menu.

This repository remains available as a read-only archive. Its complete Git history and contributor authorship were imported into `wizzomafizzo/mrext` before archival.
