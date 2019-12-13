{
    --------------------------------------------
    Filename: core.con.mcp320x.spin
    Author:
    Description:
    Copyright (c) 2019
    Started Nov 26, 2019
    Updated Nov 26, 2019
    See end of file for terms of use.
    --------------------------------------------
}

CON

' SPI Configuration
    CPOL                        = 0             ' Actually works with either
    CLK_DELAY                   = 1
    SCK_MAX_FREQ_5V             = 1_800_000
    SCK_MAX_FREQ_2_7V           = 0_900_000
    MOSI_BITORDER               = 5             'MSBFIRST
    MISO_BITORDER               = 0             'MSBPRE

' Register definitions
    START                       = $01

    FLD_SGL_DIFF                = 7
    FLD_ODD_SIGN                = 6
    FLD_MSBF                    = 5

    SINGLE_ENDED                = 1 << FLD_SGL_DIFF
    PSEUDO_DIFF                 = 0 << FLD_SGL_DIFF

    CH1                         = 1 << FLD_ODD_SIGN
    CH0                         = 0 << FLD_ODD_SIGN

    IN0POS_IN1NEG               = 1 << FLD_ODD_SIGN
    IN0NEG_IN1POS               = 0 << FLD_ODD_SIGN

    MSBFIRST                    = 1 << FLD_MSBF
    LSBFIRST                    = 0 << FLD_MSBF


PUB Null
' This is not a top-level object
