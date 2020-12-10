## Readme: Chocolatey Utils

*[Windows only]*
A collection of trivial tools that I use on top of Chocolatey.

- **checkelev** - Checks if the command prompt is elevated
- **clocal** - Lists all locally installed Chocolatey packages `choco list -l`
- **csearch** - Essentially a specialized choco search by id only `choco search %1 --by-id-only --not-broken --approved-only --pre`
- **cupall** - Chocolatey FOSS edition annoys me by creating a desktop icon for each package it installs. I do not like desktop icons. This script wraps the `cup all` command and checks and deletes any newly created desktop icons by Chocolatey.
- **link** - Simple wrapper on the awesome `shimgen` command
- **linkw** - Simple wrapper on the awesome `shimgen` command for underlying GUI executables

