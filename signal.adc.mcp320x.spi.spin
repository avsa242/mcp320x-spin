{
    --------------------------------------------
    Filename: signal.adc.mcp320x.spi.spin
    Author: Jesse Burt
    Description: Driver for Microchip MCP320x
        Analog to Digital Converters
    Copyright (c) 2021
    Started Nov 26, 2019
    Updated Jan 3, 2021
    See end of file for terms of use.
    --------------------------------------------
}

VAR

    long _CS, _SCK, _MOSI, _MISO
    word _adc_ref
    byte _ch

OBJ

    spi : "com.spi.4w"
    core: "core.con.mcp320x"
    time: "time"
    io  : "io"

PUB Null{}
' This is not a top-level object

PUB Start(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN): okay

    if lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and{
}   lookdown(MOSI_PIN: 0..31) and lookdown(MISO_PIN: 0..31)
        if okay := spi.start(core#CLK_DELAY, core#CPOL)
            time.msleep(1)
            longmove(@_CS, @CS_PIN, 4)

            io.high(_CS)
            io.output(_CS)
            defaults{}
            return okay
    return FALSE                                ' something above failed

PUB Stop{}

    spi.stop{}

PUB Defaults{}
' Factory defaults
    adcchannel(0)
    refvoltage(3_300)

PUB ADCChannel(ch)
' Set ADC channel for subsequent reads
'   Valid values: 0, 1
'   Any other value returns the current setting
    case ch
        0..1:
            _ch := ch
        other:
            return _ch

PUB ADCData{}: adc_word | cfg
' ADC data word
'   Returns: 12-bit ADC word
    case _ch
        0, 1:
            cfg := core#SINGLE_ENDED | core#MSBFIRST | (_ch << core#ODD_SIGN)
        other:
            return

    io.low(_CS)
    spi.shiftout(_MOSI, _SCK, core#MOSI_BITORDER, 4, cfg | core#START_MEAS)
    adc_word := spi.shiftin(_MISO, _SCK, core#MISO_BITORDER, 13)
    io.high(_CS)

PUB RefVoltage(v): curr_v
' Set ADC reference/supply voltage (Vdd), in millivolts
'   Valid values: 2_700..5_500
'   Any other value returns the current setting
    case v
        2_700..5_500:
            _adc_ref := v
        other:
            return _adc_ref

PUB Volts{}: v
' Return ADC reading, in milli-volts
    return (_adc_ref * adcdata{}) / 4096

DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}
