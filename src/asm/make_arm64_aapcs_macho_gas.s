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

.text
.globl _sc_make_context
.balign 16

_sc_make_context:
    ; shift address in x0 (allocated stack) to lower 16 byte boundary
    and x0, x0, ~0xF

    ; reserve space for context-data on context-stack
    sub  x0, x0, #0x70

    ; third arg of sc_make_context() == address of context-function
    ; store address as a PC to jump in
    str  x2, [x0, #0x60]

    ; compute abs address of label finish
    ; 0x0c = 3 instructions * size (4) before label 'finish'

    ; TODO: Numeric offset since llvm still does not support labels in ADR. Fix:
    ;       http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20140407/212336.html
    adr  x1, 0x0c

    ; save address of finish as return-address for context-function
    ; will be entered after context-function returns (LR register)
    str  x1, [x0, #0x58]

    ret  lr ; return pointer to context-data (x0)

finish:
    ; exit code is zero
    mov  x0, #0
    ; exit application
    bl  __exit


