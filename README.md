# Complete Ecosystem Scenario

[![Validate](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/actions/workflows/validate.yml/badge.svg)](https://github.com/ZtModArchive/Complete-Ecosystem-Scenario/actions/workflows/validate.yml)

> "_an animal was ...EATEN! (or just attacked : ) would be nice if we could differentiate the failure message depending on whether the eaten event was viewed by a guest or not..._"
>
> \- Unknown Zoo Tycoon 2 developer

This is an attempt at remaking a scrapped scenario from _Zoo Tycoon 2_, which involved putting both savannah herbivores and carnivores together in the same habitat.

## Installation

Either take the latest release or build your own `.z2f` and put the file in your root directory of your _Zoo Tycoon 2_ installation.

### Requirements

The mod might not work with all versions of _Zoo Tycoon 2_.

| Expansion | Status |
|-----------|--------|
| Zoo Tycoon 2 | ![Tested](https://img.shields.io/badge/20.09.00.0005--beta-untested-lightgrey)<br/>![Tested](https://img.shields.io/badge/20.10.00.0006-untested-lightgrey)
| Marine Mania | ![Tested](https://img.shields.io/badge/30.06.00.0001--beta-untested-lightgrey)<br/>![Tested](https://img.shields.io/badge/30.07.00.0003--beta-untested-lightgrey)
| Extinct Animals <sup>_1_</sup>  | ![Tested](https://img.shields.io/badge/32.10.00.0009-untested-lightgrey)<br/>![Tested](https://img.shields.io/badge/33.05.00.0002UO-untested-lightgrey)  |

_<sup>1</sup> This includes the installation of all prior expansions_

### Setting the scenario preview image

In order to properly display the scenario preview image, put `worldcampscen4.jpg` in the following sub-directory in the root directory of your _Zoo Tycoon 2_ installation: `maps/scenario`.


## Usage

This mod adds in a cut scenario under the _The Globe_ campaign series, it is the last one in this campaign. Completion of the prior scenarios of this campaign is required.

## Building

A vast majority of _Zoo Tycoon 2_ mods are either `.z2f` or `.zip` archives, this mod is no different. You can use Microsoft Windows' own file zipper to create zips. **CAUTION:** other zipping programs such as 7-Zip or WinRAR can compress to a `.zip` that _Zoo Tycoon 2_ does not support.

Alternatively, you can use [Castor](https://github.com/ZtModArchive/Castor) to build mods. simply use the command

```bash
castor build
```

or if you want to debug and attach _Zoo Tycoon 2_ to your console output

```bash
castor serve
```

## Credits

### Programming

- [_Apodemus_](https://github.com/Zt-freak)
- [_LoliJuicy_](https://github.com/LoliJuicy)

### Special thanks

- _Blue Fang Games_ - Map design, scenario concept and the creation of _Zoo Tycoon 2_.
- _March42_ - Publishing the Zoo Tycoon 2 Beta 20.09.00.0005
