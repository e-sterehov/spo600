.text
.globl _start

start = 0                       /* starting value for the loop index */
max = 31                        /* loop exits when the index hits this number (loop condition is i<max) */

_start:
    mov     x19,start           /* loop index */
    mov     x20,0		/* copy ascii 0 to x20 to use as a comparison for quotient */
    adr     x25,msg

loop:   
    /*** Divide ***/
    mov     x21,10              /* load x21 with 10 */
    udiv    x22,x19,x21         /* divide x19 by x21 and store quotient in x22 */     

    /*** Quotient to string ***/
    add     w24,w22,0x30        /* convert quotient to ascii */
    cmp     w24,'0'             /* compare ascii converted quotient to ascii 0 */
    beq     contd               /* if 0, jump to contd */
    strb    w24,[x25,6]         /* if not 0, include in the output */

contd:
    /*** Remainder to string ***/
    msub    x23,x22,x21,x19     /* load x23 with x19-(x22*x21) = divident - (quotient * 10) (get remainder)*/
    add     w26,w23,'0'         /* convert remainder to ascii */
    strb    w26,[x25,7]         /* store byte in msg, offset by 7 */

    /*** Print message ***/
    mov     x0, 1               /* file descriptor: 1 is stdout */
    adr     x1, msg   	        /* message location (memory address) */
    mov     x2, len   	        /* message length (bytes) */

    mov     x8, 64     	        /* write is syscall #64 */
    svc     1          	        /* invoke syscall */

    add     x19,x19,1           /* increment index */
    cmp     x19,max             /* see if we're done */
    bne     loop                /* loop if we're not */

    mov     x0, 0     	        /* status -> 0 */
    mov     x8, 93    	        /* exit is syscall #93 */
    svc     0          	        /* invoke syscall */

.data

msg:	.ascii      "Loop:   \n"
len = . - msg
