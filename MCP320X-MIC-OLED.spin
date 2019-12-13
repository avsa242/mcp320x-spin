{
    --------------------------------------------
    Filename: MCP320X-MIC-OLED.spin
    Author: Jesse Burt
    Description: Simple MIC to OLED demo, using an MCP320x ADC
        to sample the mic and display the waveform on an SSD1306-based OLED
    Copyright (c) 2019
    Started Nov 26, 2019
    Updated Dec 12, 2019
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
    oled    : "display.oled.ssd1306.i2c"
    int     : "string.integer"

VAR

    long _fps_stack[50]
    byte _disp_buff[512]
    byte _ser_cog, _fps_cog, _frame_nr

PUB Main | x, y

    Setup
    repeat
        oled.Clear

        repeat x from 0 to 127 step 4       ' Draw horizontal graticule
            oled.DrawPixel (x, 16, 1)

        repeat x from 0 to 127
            y := adc.ReadADC (0) >> 7{/128} ' Sample from microphone
            oled.DrawPixel (x, y, 1)        ' and display it on the OLED
        oled.writeBuffer
        _frame_nr++                         ' Keep track of frame numbers for framerate monitor

PUB fpscog

    repeat
        time.Sleep (1)
        ser.Position (0, 5)
        ser.Str(string("FPS: "))
        ser.Dec (_frame_nr)
        _frame_nr := 0

PUB Setup

    repeat until _ser_cog := ser.Start (115_200)
    time.msleep(100)
    ser.Clear
    ser.Str(string("Serial terminal started", ser#CR, ser#LF))
    if adc.Start (CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN)
        ser.Str(string("MCP320x driver started", ser#CR, ser#LF))
    else
        ser.Str(string("MCP320x driver failed to start - halting", ser#CR, ser#LF))
        time.MSleep (500)
        ser.Stop
        FlashLED (LED, 500)
    if oled.Startx (128, 32, 28, 29, 1_000_000, 0)
        ser.Str(string("SSD1306 driver started", ser#CR, ser#LF))
        oled.Defaults
        oled.OSCFreq (407)
        oled.DrawBuffer (@_disp_buff)
        oled.Clear
        oled.writeBuffer
    else
        ser.Str (string("SSD1306 driver failed to start - halting"))
        oled.Stop
        time.MSleep (500)
        ser.Stop
        FlashLED (LED, 500)
    cognew(fpscog, @_fps_stack)

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
