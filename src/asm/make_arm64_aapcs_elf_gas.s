/*
            Copyright Edward Nevill + Oliver Kowalke 2015
   Distributed under the Boost Software License, Version 1.0.
      (See accompanying file LICENSE_1_0.txt or copy at
          http://www.boost.org/LICENSE_1_0.txt)
*/
/*******************************************************
 *                                                     *
 *  -------------------------------------------------  *
 *  |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  *
 *  -------------------------------------------------  *
 *  | 0x0 | 0x4 | 0x8 | 0xc | 0x10| 0x14| 0x18| 0x1c|  *
 *  -------------------------------------------------  *
 *  |    x19    |    x20    |    x21    |    x22    |  *
 *  -------------------------------------------------  *
 *  -------------------------------------------------  *
 *  |  8  |  9  |  10 |  11 |  12 |  13 |  14 |  15 |  *
 *  -------------------------------------------------  *
 *  | 0x20| 0x24| 0x28| 0x2c| 0x30| 0x34| 0x38| 0x3c|  *
 *  -------------------------------------------------  *
 *  |    x23    |    x24    |    x25    |    x26    |  *
 *  -------------------------------------------------  *
 *  -------------------------------------------------  *
 *  |  16 |  17 |  18 |  19 |  20 |  21 |  22 |  23 |  *
 *  -------------------------------------------------  *
 *  | 0x40| 0x44| 0x48| 0x4c| 0x50| 0x54| 0x58| 0x5c|  *
 *  -------------------------------------------------  *
 *  |    x27    |    x28    |    FP     |     LR    |  *
 *  -------------------------------------------------  *
 *  -------------------------------------------------  *
 *  |  24 |  25 |  26 |  27 |  28 |  29 |  30 |  31 |  *
 *  -------------------------------------------------  *
 *  | 0x60| 0x64| 0x68| 0x6c| 0x70| 0x74| 0x78| 0x7c|  *
 *  -------------------------------------------------  *
 *  |     PC    |   align   |           |           |  *
 *  -------------------------------------------------  *
 *                                                     *
 *******************************************************/

.cpu    generic+fp+simd
.text
.align  2
.global sc_make_context
.type   sc_make_context, %function
sc_make_context:
    # shift address in x0 (allocated stack) to lower 16 byte boundary
    and x0, x0, ~0xF

    # reserve space for context-data on context-stack
    sub  x0, x0, #0x70

    # third arg of sc_make_context() == address of context-function
    # store address as a PC to jump in
    str  x2, [x0, #0x60]

    # save address of finish as return-address for context-function
    # will be entered after context-function returns (LR register)
    adr  x1, finish
    str  x1, [x0, #0x58]

    ret  x30 // return pointer to context-data (x0)

finish:
    # exit code is zero
    mov  x0, #0
    # exit application
    bl  _exit

.size   sc_make_context,.-sc_make_context
# Mark that we don't need executable stack.
.section .note.GNU-stack,"",%progbits
