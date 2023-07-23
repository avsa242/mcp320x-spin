{
    --------------------------------------------
    Filename: signal.adc.mcp320x.spin
    Author: Jesse Burt
    Description: Driver for Microchip MCP320x and 300x Analog to Digital Converters
    Copyright (c) 2023
    Started Nov 26, 2019
    Updated Jul 23, 2023
    See end of file for terms of use.
    --------------------------------------------
}
    { default I/O settings; these can be overridden in the parent object }
    CS          = 0
    SCK         = 1
    MOSI        = 2
    MISO        = 3

#include "signal.adc.common.spinh"

VAR

    long _CS
    long _adc_ref
    long _adc_rdbits, _adc_range, _adc_max
    byte _max_channels, _ch

OBJ

    spi : "com.spi.1mhz"
    core: "core.con.mcp320x"
    time: "time"
    u64 : "math.unsigned64"

PUB null()
' This is not a top-level object

PUB start(): status
' Start the driver using default I/O settings
    return startx(CS, SCK, MOSI, MISO)

PUB startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN): status
' Start the driver, using custom I/O settings
    if ( lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and ...
        lookdown(MOSI_PIN: 0..31) and lookdown(MISO_PIN: 0..31) )
        if ( status := spi.init(SCK_PIN, MOSI_PIN, MISO_PIN, core#SPI_MODE) )
            time.msleep(1)
            _CS := CS_PIN
            outa[_CS] := 1
            dira[_CS] := 1

            defaults()
            return status
    ' if this point is reached, something above failed
    ' Double check I/O pin assignments, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE

PUB stop()
' Stop the driver
    spi.deinit()
    _CS := 0
    _adc_ref := 0
    _ch := 0

PUB defaults()
' Factory defaults
    set_model(3001)
    set_adc_channel(0)
    set_ref_voltage(3_300000)

PUB adc_channel(): ch
' Get currently set ADC channel (cached)
    return _ch

PUB adc_data(): adc_word | cfg
' ADC data word
'   Returns: 12-bit ADC word
    case _ch
        0, 1:
            cfg := core#SINGLE_ENDED | core#MSBFIRST | (_ch << core#ODD_SIGN)
        other:
            return

    outa[_CS] := 0
    spi.wrbits_msbf((core.START_MEAS | cfg), 4)
    adc_word := (spi.rdbits_msbf(_adc_rdbits) & $fff)    ' 1 null bit + 12 data bits
    outa[_CS] := 1

PUB adc2volts(adc_word): volts
' Scale ADC word to microvolts
    return u64.multdiv(_adc_ref, adc_word, _adc_range)

PUB opmode(m)
' dummy method for API compatibility with other drivers

PUB ref_voltage(): v
' Get currently set reference voltage
'   Returns: microvolts
    return _adc_ref

PUB set_adc_channel(ch)
' Set ADC channel for subsequent reads
'   Valid values: 0, 1
    _ch := 0 #> ch <# 1

PUB set_adc_res(bits)
' Set ADC resolution
'   Valid values: 10, 12 (other values ignored)
    if ( lookdown(bits: 10, 12) )
        _adc_rdbits := bits+1
        _adc_range := (1 << bits)
        _adc_max := _adc_range-1

pub set_model(m) | tmp
' Set ADC model
'   Valid values:
'       10-bit models: 3001, 3002, 3004, 3008
'       12-bit models: 3201, 3202, 3204, 3208
    case m
        3001, 3002, 3004, 3008:
            set_adc_res(10)
        3201, 3202, 3204, 3208:
            set_adc_res(12)

PUB set_ref_voltage(v): curr_v
' Set ADC reference/supply voltage (Vdd), in microvolts
'   Valid values: 2_700_000..5_500_000 (2.7 .. 5.5V)
    _adc_ref := (2_700000 #> v <# 5_500000)

DAT
{
Copyright 2022 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

