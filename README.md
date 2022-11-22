# mcp320x-spin 
--------------

This is a P8X32A/Propeller driver object for the Microchip MCP320x-series ADCs

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.

## Salient Features

* SPI connection at 1MHz (P1), up to 1.8MHz (P2)
* Read channel 0 or 1
* Read raw ADC counts or voltage
* Set reference voltage from 2.7v to 5.5v

## Requirements

P1/SPIN1:
* 1 extra core/cog for the PASM SPI engine (none if bytecode engine is used)
* signal.adc.common.spinh (provided by spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* signal.adc.common.spin2h (provided by p2-spin-standard-library)

## Compiler Compatibility

| Processor | Language | Compiler               | Backend     | Status                |
|-----------|----------|------------------------|-------------|-----------------------|
| P1        | SPIN1    | FlexSpin (5.9.14-beta) | Bytecode    | OK                    |
| P1        | SPIN1    | FlexSpin (5.9.14-beta) | Native code | Runs, but buggy       |
| P1        | SPIN1    | OpenSpin (1.00.81)     | Bytecode    | Untested (deprecated) |
| P2        | SPIN2    | FlexSpin (5.9.14-beta) | NuCode      | Runs, but buggy       |
| P2        | SPIN2    | FlexSpin (5.9.14-beta) | Native code | Not yet implemented   |
| P1        | SPIN1    | Brad's Spin Tool (any) | Bytecode    | Unsupported           |
| P1, P2    | SPIN1, 2 | Propeller Tool (any)   | Bytecode    | Unsupported           |
| P1, P2    | SPIN1, 2 | PNut (any)             | Bytecode    | Unsupported           |

## Limitations

* Tested only with 2-channel model (MCP3202)

