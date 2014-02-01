.text
.globl    _start

start = 0                       /* starting value for the loop index */
max = 31                        /* loop exits when the index hits this number (loop condition is i<max) */

_start:
    mov     $start,%r15         /* loop index */
    mov     $'0',%r12		/* copy ascii 0 to r11 to use as a comparison for quotient */

loop:
    mov     $0,%rdx             /* Clear the remainder */
    
    /* Divide */
    mov     %r15,%rax           /* Copy r15 into rax to be used as divident */
    mov     $10,%r10            /* Store 10 into r12 to be used as divisor */
    div     %r10                /* divide value of r15 by 10 */     
    
    /* Quotient */
    mov     %rax,%r13           /* copy quotient to r13 */
    add     $'0',%r13           /* convert r13 to ascii */
    cmp     %r12,%r13           /* check if quotient is 0 */
    je      contd               /* if equal, skip to contd lable */
    mov     %r13b,msg+6         /* if quotient is not 0, set it as the first number */

contd:
    /* Remainder */
    mov     %rdx,%r14           /* copy remainder to r14 */
    add     $'0',%r14           /* convert r14 to ascii */
    mov     %r14b,msg+7         /* move a single byte into memory position of msg+7 */

    /* Print message */
    mov     $len,%rdx	        /* message length */
    mov     $msg,%rsi           /* message location */
    mov     $1,%rdi	        /* file descriptor stdout */
    mov     $1,%rax	        /* syscall sys_write */
    syscall

    inc     %r15                /* increment index */
    cmp     $max,%r15           /* see if we're done */
    jne     loop                /* loop if we're not */

    mov     $0,%rdi             /* exit status */
    mov     $60,%rax            /* syscall sys_exit */
    syscall

.data

msg:	.ascii      "Loop:   \n"
	len = . - msg
