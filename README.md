# Complete Ecosystem Scenario

[![Validate](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/actions/workflows/validate.yml/badge.svg)](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/actions/workflows/validate.yml)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/ZtModArchive/Complete-Ecosystem-Scenario)](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/releases)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a6362bbac57d4243a1be0b8cb31c8ace)](https://www.codacy.com/gh/ZtModArchive/Complete-Ecosystem-Scenario/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ZtModArchive/Complete-Ecosystem-Scenario&amp;utm_campaign=Badge_Grade)
[![License](https://img.shields.io/github/license/ZtModArchive/Complete-Ecosystem-Scenario)](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/blob/main/LICENSE)
[![Matrix](https://img.shields.io/matrix/ztmodarchive:matrix.org)](https://matrix.to/#/#ztmodarchive:matrix.org)

> "_an animal was ...EATEN! (or just attacked : ) would be nice if we could differentiate the failure message depending on whether the eaten event was viewed by a guest or not..._"
>
> \- Unknown Zoo Tycoon 2 developer

This is an attempt at restoring a scrapped scenario from _Zoo Tycoon 2_, which involved putting both savannah herbivores and carnivores together in the same habitat.

## License

The following code, except for Microsoft's work (e.g. `worldcampscen4.dat` and `worldcampscen4.jpg`), is available under the GNU General Public License.

## Installation

Either take the latest release or build your own `.z2f` and put the file in your root directory of your _Zoo Tycoon 2_ installation.

### Requirements

The mod might not work with all versions of _Zoo Tycoon 2_.

| Expansion<sup>_*_</sup> | Status |
|-----------|--------|
| Zoo Tycoon 2 | ![Tested](https://img.shields.io/badge/20.09.00.0005--beta-untested-inactive)<br/>![Tested](https://img.shields.io/badge/20.10.00.0006-untested-inactive)
| Endangered Species | |
| African Adventure | |
| Marine Mania | ![Tested](https://img.shields.io/badge/30.06.00.0001--beta-tested-success)<br/>![Tested](https://img.shields.io/badge/30.07.00.0003--beta-tested-success)
| Extinct Animals  | ![Tested](https://img.shields.io/badge/32.10.00.0009-tested-success)<br/>![Tested](https://img.shields.io/badge/33.05.00.0002UO-tested-success)  |

_<sup>*</sup> Except for beta releases, this includes the installation of all prior expansions._

### Setting the scenario preview image

In order to properly display the scenario preview image, put `worldcampscen4.jpg` in the following sub-directory in the root directory of your _Zoo Tycoon 2_ installation: `maps/scenario`.
Alternatively you may add it to your `.z2f` but don't compress the jpg file. Castor versions before 4.2.1 do not support no-compression addition to `.z2f` archives.

## Features

This mod adds in a cut scenario under the _The Globe_ campaign series, it is the last one in this campaign (fourth in beta 1).

- [x] Check if 6 savannah herbivores and 4 savannah carnivores are in the same habitat.
- [x] Check if a savannah herbivore has been attacked and killed.
- [x] Check if a guest has witnessed the attack.
- [x] Check if a 4 months have passed with enough savannah animals sharing the same habitat

### Language support

- Chinese (Traditional)
- Dutch
- English
- French
- German
- Japanese
- Korean
- Portuguese (Brazil)
- Spanish

## Building

A vast majority of _Zoo Tycoon 2_ mods are either `.z2f` or `.zip` archives, this mod is no different. You can use Microsoft Windows' own file zipper to create zips.

**CAUTION:** Other zipping programs such as 7-Zip or WinRAR manually compress the `.zip` archives that _Zoo Tycoon 2_ does not support. In most cases, they can be read except a few file formats. You'll need to do extra steps if you want to exclude some files from being fully compressed.

Alternatively, you can use [Castor](https://github.com/ZtModArchive/Castor) to build mods. Simply use the command

```bash
castor build
```

or if you want to debug and attach _Zoo Tycoon 2_ to your console output

```bash
castor serve
```

**CAUTION:** Only Castor version 4.2.1 or higher supports adding the jpg scenario preview image, because it needs to be added as an uncompressed file in order to function properly.

## Credits

### Programming

- [_Apodemus_](https://github.com/Zt-freak)
- [_LoliJuicy_](https://github.com/LoliJuicy)
- [_Thom_](https://github.com/TheThommerd)

### Translation

- [_Apodemus_](https://github.com/Zt-freak) - Dutch, English
- _DarthQuell_ - Spanish
- _DL_Baryonyx_ - French
- _Jorge Gabriel_ - Portuguese (Brazil)
- _Lelka_ - Korean
- [_LoliJuicy_](https://github.com/LoliJuicy) - Chinese, English, Japanese (rough translation)
- [_HENDRIX_](https://github.com/HENDRIX-ZT2) - German

### Special thanks

- _Blue Fang Games_ - Map design, scenario concept and the creation of _Zoo Tycoon 2_.
- _March42_ - Publishing the Zoo Tycoon 2 Beta 20.09.00.0005
