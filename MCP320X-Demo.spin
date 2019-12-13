{
    --------------------------------------------
    Filename: MCP320X-Demo.spin
    Author: Jesse Burt
    Description: Simple demo of the MCP320x driver that continuously shows
        either the raw ADC counts or Voltage sampled by the ADC
    Copyright (c) 2019
    Started Nov 26, 2019
    Updated Nov 26, 2019
    See end of file for terms of use.
    --------------------------------------------
}

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq

    LED         = cfg#LED1

    CS_PIN      = 0
    SCK_PIN     = 2
    MOSI_PIN    = 5
    MISO_PIN    = 4

OBJ

    cfg     : "core.con.boardcfg.flip"
    ser     : "com.serial.terminal.ansi"
    time    : "time"
    io      : "io"
    adc     : "signal.adc.mcp320x.spi"
    int     : "string.integer"

VAR

    byte _ser_cog

PUB Main

    Setup
    repeat
        ser.Position (0, 5)
        ser.Str("ADC: "))
'        ser.Str(int.DecPadded (adc.ReadADC(0), 5))
'        ser.Str(int.HexIndicated (adc.ReadADC(0), 8))
        ser.Str(int.DecPadded (adc.Voltage(0), 5))

PUB Setup

    repeat until _ser_cog := ser.Start (115_200)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#CR, ser#LF))
    if adc.Start (CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN)
        ser.Str(string("MCP320x driver started", ser#CR, ser#LF))
    else
        ser.Str(string("MCP320x driver failed to start - halting", ser#CR, ser#LF))
        time.MSleep (500)
        ser.Stop
        FlashLED (LED, 500)

PUB FlashLED(led_pin, delay_ms)

    io.Output (led_pin)
    repeat
        io.Toggle (led_pin)
        time.MSleep (delay_ms)

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
