# mcp320x-spin 
--------------

This is a P8X32A/Propeller driver object for the Microchip MCP320x-series ADCs

## Salient Features

* Read channel 0 or 1
* Methods to return raw ADC counts or Voltage scaled to 5V

## Requirements

* 1 extra core/cog for the PASM SPI driver

## Compiler Compatibility

* OpenSpin (tested with 1.00.81)
* FastSpin (tested with 4.0.3)

## Limitations

* Very early in development - may malfunction, or outright fail to build
* Scaled voltage values currently hardcoded for 5V reference
* Tested only with 2-channel model (MCP3202)

## TODO

- [ ] Scale voltage to 3.3V reference
- [ ] Support 4, 8 channel models
