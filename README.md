# gf180mcu Caravel Template

Project template for wafer.space MPW runs using the gf180mcu PDK with integrated Caravel core. Based on the [gf180mcu-project-template](https://github.com/wafer-space/gf180mcu-project-template) with Caravel core which is essentially a simplified fork of the [GF180MCU Caravel by eFabless](https://github.com/efabless/caravel-gf180mcu) used during OpenMPW GF180MCU runs.

## Implement the Design

This repository contains a Nix flake that provides a shell with the [`leo/gf180mcu`](https://github.com/librelane/librelane/tree/leo/gf180mcu) branch of LibreLane.

Simply run `nix-shell` in the root of this repository.

With this shell enabled, run the implementation, first clone the PDK

```
make clone-pdk
```
and them make the Caravel core (can be skipped as all required files are already in the repository):

```
make caravel-librelane
```

After Caravel implementation is done run the implementation of the chip top:

```
make librelane
```

For more info, see the original [gf180mcu-project-template](https://github.com/wafer-space/gf180mcu-project-template).

## Caravel core

Only part of Caravel core was ported for this project. Management processor, user wishbone bus, housekeeping SPI, PLL and GPIO config blocks are present, but padframe and user area are not. Also a total number of pads used by Caravel was reduced to 18 of which 13 could be configured for user IO bypass. All Caravel logic including GPIO config blocks are now placed inside the core area. No "frame" is going around the user project, and user project itself should be implemented inside the upper level template (chip_core.sv) and connected to the remaining pads directly.

## Integrating user design with Caravel

TODO

## Verification and Simulation

TODO

