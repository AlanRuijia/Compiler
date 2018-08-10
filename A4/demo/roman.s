#-------------------------------------
# a		INT	0	0
# c		INT	0	16
# 0		INT	0	32
# b		INT	0	48
# 1		INT	0	64
# x		INT	0	80
# L_1		LABEL	0	0
# L_2		LABEL	0	16
# L_3		LABEL	0	48
# L_4		LABEL	0	64
# L_5		LABEL	0	0
# L_6		LABEL	0	32
# L_7		LABEL	0	64
# L_8		LABEL	0	96
# L_9		LABEL	0	128
# L_10		LABEL	0	144
# L_11		LABEL	0	224
# L_12		LABEL	0	256
# L_13		LABEL	0	288
# L_14		LABEL	0	320
# L_15		LABEL	0	336
# L_16		LABEL	0	352
# L_17		LABEL	0	368
# L_18		LABEL	0	0
# L_19		LABEL	0	16
# L_20		LABEL	0	48
# L_21		LABEL	0	96
# L_22		LABEL	0	112
# L_23		LABEL	0	128
# L_24		LABEL	0	176
# L_25		LABEL	0	192
# L_26		LABEL	0	208
# L_27		LABEL	0	224
# L_28		LABEL	0	240
# L_29		LABEL	0	272
# L_30		LABEL	0	288
# L_31		LABEL	0	304
# L_32		LABEL	0	336
# L_33		LABEL	0	352
# L_34		LABEL	0	384
# L_35		LABEL	0	400
# L_36		LABEL	0	448
# L_37		LABEL	0	480
# L_38		LABEL	0	496
# L_39		LABEL	0	512
# L_40		LABEL	0	560
# L_41		LABEL	0	576
# L_42		LABEL	0	592
# L_43		LABEL	0	640
# L_44		LABEL	0	656
# L_45		LABEL	0	672
# L_46		LABEL	0	720
# L_47		LABEL	0	736
# L_48		LABEL	0	752
# "continue"		STR	0	768
# L_49		LABEL	0	800
# L_50		LABEL	0	816
# L_51		LABEL	0	832
# L_52		LABEL	0	848
# "break"		STR	0	864
# L_53		LABEL	0	896
# L_54		LABEL	0	912
# L_55		LABEL	0	928
# L_56		LABEL	0	944
# L_57		LABEL	0	960
# L_58		LABEL	0	992
#-------------------------------------
#-------------------------------------
# fun		INT	0	96
# 80		INT	0	80
# pop		INT	0	96
# 384		INT	0	384
# main		INT	0	400
# 1008		INT	0	1008
#-------------------------------------
#-------------------------------------
#-------------------------------------
#-------------------------------------
# t_0		INT	0	32
#-------------------------------------
#-------------------------------------
# a		INT	0	16
# b		INT	0	48
# c		INT	0	80
# d		BOOLEAN	0	112
#-------------------------------------
#-------------------------------------
# 10		INT	0	160
# 10		INT	0	176
# t_1		INT	0	192
# t_2		INT	0	208
# t_3		INT	0	240
# t_4		INT	0	272
# t_5		INT	0	304
#-------------------------------------
#-------------------------------------
#-------------------------------------
#-------------------------------------
# 10		INT	0	32
# 5		INT	0	64
# t_6		BOOLEAN	0	80
# 6		INT	0	144
# t_7		BOOLEAN	0	160
# 0		INT	0	976
#-------------------------------------
#-------------------------------------
# 3		INT	0	256
#-------------------------------------
#-------------------------------------
# 10		INT	0	320
# t_8		INT	0	368
#-------------------------------------
#-------------------------------------
# t_9		INT	0	416
# t_10		INT	0	432
# t_11		INT	0	464
# 3		INT	0	528
# t_12		BOOLEAN	0	544
#-------------------------------------
#-------------------------------------
# 3		INT	0	608
# t_13		BOOLEAN	0	624
# 10		INT	0	688
# t_14		BOOLEAN	0	704
#-------------------------------------
#-------------------------------------
# printf		STR	0	784
#-------------------------------------
#-------------------------------------
#-------------------------------------
#-------------------------------------
# printf		STR	0	880
#-------------------------------------
.globl main
.data
a: .quad 0
c: .quad 0
b: .quad 0
x: .quad 1
str768: .asciz "continue"
str864: .asciz "break"
.text

#fun:   
fun: push %rbp
mov %rsp, %rbp


#L_1: 80 frame 
L_1: sub $80, %rsp


#L_2: t_0 = a + b
L_2: mov a, %rax
mov b, %rbx
add %rbx, %rax
mov %rax, -32(%rbp)


#L_3: 80 = t_0 ret 
L_3: mov -32(%rbp), %rax
add $80, %rsp
pop %rbp
ret


#pop:   
pop: push %rbp
mov %rsp, %rbp


#L_5: 384 frame 
L_5: sub $384, %rsp


#L_6:  push %rdi 
L_6: 

#L_7:  push %rsi 
L_7: 

#L_8:  push %rdx 
L_8: 

#L_9:  push %rcx 
L_9: 

#L_10: t_1 = a * 10
L_10: 

#L_11: t_2 = 10 + t_1
L_11: mov $10, %rax
mov -192(%rbp), %rbx
add %rbx, %rax
mov %rax, -208(%rbp)


#L_12: t_3 = a / t_2
L_12: 

#L_13: t_4 = t_3 * t_2
L_13: 

#L_14: t_5 = a - t_4
L_14: 

#L_15: a = t_5 = 
L_15: mov -304(%rbp), %rax
mov %rax, -16(%rbp)


#L_16: 384 = a ret 
L_16: mov -16(%rbp), %rax
add $384, %rsp
pop %rbp
ret


#main:   
main: push %rbp
mov %rsp, %rbp


#L_18: 1008 frame 
L_18: sub $1008, %rsp


#L_19: a = 10 = 
L_19: mov $10, %rax
mov %rax, a


#L_20: t_6 = a cmp 5
L_20: 

#L_21: L_23 = t_6 jg 
L_21: 

#L_22: L_31 = t_6 jle 
L_22: 

#L_23: t_7 = a cmp 6
L_23: 

#L_24: L_26 = t_7 jl 
L_24: 

#L_25: L_31 = t_7 jge 
L_25: 

#L_26: a rdi 
L_26: 

#L_27: b rsi 
L_27: 

#L_28: c rdx 
L_28: 

#L_29:  = pop call 3
L_29: 

#L_30: L_57 goto 
L_30: 

#L_31: b = 10 = 
L_31: mov $10, %rax
mov %rax, b


#L_32: x = a = 
L_32: mov a, %rax
mov %rax, x


#L_33: t_8 = x cmp b
L_33: 

#L_34: L_57 = t_8 jle 
L_34: 

#L_35: t_9 = c / x
L_35: 

#L_36: t_10 = t_9 * x
L_36: 

#L_37: t_11 = c - t_10
L_37: 

#L_38: c = t_11 = 
L_38: mov -464(%rbp), %rax
mov %rax, c


#L_39: t_12 = c cmp 3
L_39: 

#L_40: L_42 = t_12 je 
L_40: 

#L_41: L_55 = t_12 jne 
L_41: 

#L_42: t_13 = a cmp 3
L_42: 

#L_43: L_48 = t_13 je 
L_43: 

#L_44: L_45 = t_13 jne 
L_44: 

#L_45: t_14 = a cmp 10
L_45: 

#L_46: L_48 = t_14 jne 
L_46: 

#L_47: L_52 = t_14 je 
L_47: 

#L_48: "continue" rdi 
L_48: 

#L_49:  = printf call 1
L_49: 

#L_50: L_55 goto 
L_50: 

#L_51: L_55 goto 
L_51: 

#L_52: "break" rdi 
L_52: 

#L_53:  = printf call 1
L_53: 

#L_54: L_57 goto 
L_54: 

#L_55: x = x + 1
L_55: mov x, %rax
mov $1, %rbx
add %rbx, %rax
mov %rax, x


#L_56: L_33 goto 
L_56: 

#L_57: 1008 = 0 ret 
L_57: mov -976(%rbp), %rax
add $1008, %rsp
pop %rbp
ret

