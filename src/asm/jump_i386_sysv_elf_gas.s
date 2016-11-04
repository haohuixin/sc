/*
            Copyright Oliver Kowalke 2009.
   Distributed under the Boost Software License, Version 1.0.
      (See accompanying file LICENSE_1_0.txt or copy at
          http://www.boost.org/LICENSE_1_0.txt)
*/

/*****************************************************************************************
 *                                                                                       *
 *  -----------------------------------------------------------------------------------  *
 *  |    0    |    1    |    2    |    3    |    4     |    5    |    6     |    7    |  *
 *  -----------------------------------------------------------------------------------  *
 *  |   0x0   |   0x4   |   0x8   |   0xc   |   0x10   |   0x14  |   0x18   |   0x1c  |  *
 *  -----------------------------------------------------------------------------------  *
 *  |   EDI   |   ESI   |   EBX   |   EBP   |   EIP    |  hidden |    to    |   data  |  *
 *  -----------------------------------------------------------------------------------  *
 *                                                                                       *
 *****************************************************************************************/

.text
.globl sc_jump_context
.align 2
.type sc_jump_context,@function
sc_jump_context:
    pushl  %ebp  /* save EBP */
    pushl  %ebx  /* save EBX */
    pushl  %esi  /* save ESI */
    pushl  %edi  /* save EDI */

    /* store sc_context_sp_t in ECX */
    movl  %esp, %ecx

    /* first arg of sc_jump_context() == fcontext to jump to */
    movl  0x18(%esp), %eax

    /* second arg of sc_jump_context() == data to be transferred */
    movl  0x1c(%esp), %edx

    /* restore ESP (pointing to context-data) from EAX */
    movl  %eax, %esp

    /* address of returned transport_t */
    movl 0x14(%esp), %eax
    /* return parent sc_context_sp_t */
    movl  %ecx, (%eax)
    /* return data */
    movl %edx, 0x4(%eax)

    popl  %edi  /* restore EDI */
    popl  %esi  /* restore ESI */
    popl  %ebx  /* restore EBX */
    popl  %ebp  /* restore EBP */

    /* jump to context */
    ret $4
.size sc_jump_context,.-sc_jump_context

/* Mark that we don't need executable stack.  */
.section .note.GNU-stack,"",%progbits
