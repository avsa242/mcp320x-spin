# mcp320x-spin 
--------------

This is a P8X32A/Propeller driver object for the Microchip MCP320x and MCP300x series ADCs

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* SPI connection at 1MHz (P1), up to 1.8MHz (P2)
* Read channels 0..7 (availability dependent on model)
* Read raw ADC counts or voltage
* Set reference voltage (in microvolts) from 2.7v to 5.5v
* Set ADC resolution (explicitly, or implicitly by model number)


## Requirements

P1/SPIN1:
* 1 extra core/cog for the PASM SPI engine (none if bytecode engine is used)
* signal.adc.common.spinh (provided by spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* signal.adc.common.spin2h (provided by p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.8.0)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.8.0)       | Native/PASM  | Runs, but buggy       |
| P2        | SPIN2    | FlexSpin (6.8.0)       | NuCode       | Runs, but buggy       |
| P2        | SPIN2    | FlexSpin (6.8.0)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware compatibility

* Tested with MCP3002, MCP3202, MCP3208


## Limitations

* TBD

