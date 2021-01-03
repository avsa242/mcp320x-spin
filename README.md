# mcp320x-spin 
--------------

This is a P8X32A/Propeller driver object for the Microchip MCP320x-series ADCs

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* SPI connection at 1MHz (P1)
* Read channel 0 or 1
* Read raw ADC counts or voltage
* Set reference voltage from 2.7v to 5.5v

## Requirements

P1/SPIN1:
* spin-standard-library
* 1 extra core/cog for the PASM SPI driver

~~P2/SPIN2:~~
* ~~p2-spin-standard-library~~

## Compiler Compatibility

* P1/SPIN1: OpenSpin (tested with 1.00.81), FlexSpin (tested with 5.0.0)
* ~~P2/SPIN2: FlexSpin (tested with 5.0.0)~~ _(not implemented yet)_
* ~~BST~~ (incompatible - no preprocessor)
* ~~Propeller Tool~~ (incompatible - no preprocessor)
* ~~PNut~~ (incompatible - no preprocessor)

## Limitations

* Very early in development - may malfunction, or outright fail to build
* Tested only with 2-channel model (MCP3202)

## TODO

- [x] User-settable reference voltage
- [ ] Support 4, 8 channel models
- [ ] Support 10-bit models
