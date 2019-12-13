{
    --------------------------------------------
    Filename: signal.adc.mcp320x.spi.spin
    Author: Jesse Burt
    Description: Driver for the Microchip MCP320x-series
        Analog to Digital Converters
    Copyright (c) 2019
    Started Nov 26, 2019
    Updated Dec 12, 2019
    See end of file for terms of use.
    --------------------------------------------
}

CON


VAR

    byte _CS, _MOSI, _MISO, _SCK
    byte _ch

OBJ

    spi : "com.spi.4w"
    core: "core.con.mcp320x"
    time: "time"
    io  : "io"

PUB Null
''This is not a top-level object

PUB Start(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN) : okay

    okay := Startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN, core#CLK_DELAY, core#CPOL)

PUB Startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN, SCK_DELAY, SCK_CPOL): okay
    if SCK_DELAY => 1 and lookdown(SCK_CPOL: 0, 1)
        if okay := spi.start (SCK_DELAY, SCK_CPOL)              'SPI Object Started?
            time.MSleep (1)
            _CS := CS_PIN
            _MOSI := MOSI_PIN
            _MISO := MISO_PIN
            _SCK := SCK_PIN

            io.High(_CS)
            io.Output(_CS)

            return okay
    return FALSE                                                'If we got here, something went wrong

PUB Stop

    spi.stop

PUB ReadADC(ch)

    case ch
        0: ch := core#SINGLE_ENDED | core#CH0 | core#MSBFIRST
        1: ch := core#SINGLE_ENDED | core#CH1 | core#MSBFIRST
        OTHER:
            return FALSE

    readReg(ch, 2, @result)

PUB Voltage(ch) | tmp
' Return ADC reading, in milli-volts
    tmp := (ReadADC(ch) * 1_000) / 4096
    result := tmp * 5

PRI readReg(reg, nr_bytes, buff_addr) | cmd_packet, tmp

'    case reg
'        $00, $20, $40, $60, $80, $A0, $C0, $E0:
            io.Low(_CS)
            spi.SHIFTOUT (_MOSI, _SCK, core#MOSI_BITORDER, 8, core#START)
            spi.SHIFTOUT (_MOSI, _SCK, core#MOSI_BITORDER, 3, reg)

'            spi.SHIFTOUT (_MOSI, _SCK, core#MOSI_BITORDER, 11, (core#START << 8) | reg)

            word[buff_addr][0] := spi.SHIFTIN (_MISO, _SCK, core#MISO_BITORDER, 13)
            io.High(_CS)
'        OTHER:

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
