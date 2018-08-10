#-------------------------------------
# a		INT	0	0
# L_1		LABEL	0	0
# L_2		LABEL	0	16
# L_3		LABEL	0	48
# L_4		LABEL	0	96
# L_5		LABEL	0	112
# L_6		LABEL	0	128
# "equal\n"		STR	0	144
# L_7		LABEL	0	192
# L_8		LABEL	0	208
# L_9		LABEL	0	224
# L_10		LABEL	0	256
# "a = 1\n"		STR	0	272
# L_11		LABEL	0	288
# L_12		LABEL	0	304
# L_13		LABEL	0	320
# L_14		LABEL	0	352
#-------------------------------------
#-------------------------------------
# main		INT	0	16
# 368		INT	0	368
#-------------------------------------
#-------------------------------------
#-------------------------------------
#-------------------------------------
# 10		INT	0	32
# 10		INT	0	64
# t_0		BOOLEAN	0	80
# 0		INT	0	336
#-------------------------------------
#-------------------------------------
# printf		STR	0	160
# 1		INT	0	176
# 1		INT	0	240
#-------------------------------------
.globl main
.data
a: .quad 0
str144: .asciz "equal\n"
str272: .asciz "a = 1\n"
.text

#main:   
main: push %rbp
mov %rsp, %rbp


#L_1: 368 frame 
L_1: sub $368, %rsp


#L_2: a = 10 = 
L_2: mov $10, %rax
mov %rax, a


#L_3: t_0 = a cmp 10
L_3: mov a, %rax
mov $10, %rbx
cmp %rax, %rbx


#L_4: L_6 = t_0 je 
L_4: je L_6


#L_5: L_13 = t_0 jne 
L_5: jne L_13


#L_6: "equal\n" rdi 
L_6: mov $str144, %rdi


#L_7:  = printf call 1
L_7: call printf


#L_8: L_13 goto 
L_8: jmp L_13


#L_9: a = 1 = 
L_9: mov $1, %rax
mov %rax, a


#L_10: "a = 1\n" rdi 
L_10: mov $str272, %rdi


#L_11:  = printf call 1
L_11: call printf


#L_12: L_3 goto 
L_12: jmp L_3


#L_13: 368 = 0 ret 
L_13: mov -336(%rbp), %rax
add $368, %rsp
pop %rbp
ret

