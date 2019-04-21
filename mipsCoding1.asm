	.data
	
Upchar:	.asciiz 
	"Alpha","Bravo","China","Delta","Echo","Foxtrot","Golf","Hotel",
	"India","Juliet","Kilo","Lima","Mary","November","Oscar","Paper",
	"Quebec","Research","Sierra","Tango","Uniform","Victor","Whisky",
	"X-ray","Yankee","Zulu"
#Upcase's Address Bias
Upcharoffset: .word
	0,6,12,18,24,29,37,42,48,54,61,66,71,76,85,91,97,104,113,120,
	126,134,141,148,154,161

lowchar: .asciiz 
	"alpha","bravo","china","delta","echo","foxtrot","golf","hotel",
	"india","juliet","kilo","lima","mary","november","oscar","paper",
	"quebec","research","sierra","tango","uniform","victor","whisky",
	"x-ray","yankee","zulu"
lowcharoffset: .word
	0,6,12,18,24,29,37,42,48,54,61,66,71,76,85,91,97,104,113,120,
	126,134,141,148,154,161

number: .asciiz 
	"zero","First","Second","Third","Fourth","Fifth","Sixth","Seventh",
	"Eighth","Ninth"
numberoffset: .word
	0,5,11,18,24,31,37,43,51,58
nextline: .asciiz
	"\n"
other: .asciiz 
	"*"
	
	
	.text 
	.globl main
main: li $v0, 12  #12 opeartor read one charcater
	syscall
	
	# whether the read char is '?' //'?' ascii = 63
	sub $t1, $v0, 63 
	beqz $t1, exit #compare t1 with 0, if 0 then quit
	
	#whether the char is Upcase(A-Z)
	sub $t1, $v0, 65
	sub $t2, $v0, 90
	slt $s0, $t1, $0 #if t1>=0,then s0=0
	slt $s1, $0, $t2 #if t2>=0, then s1=0
	xor $t2, $s0, $s1 #if both s0 s1 == 0, then it is Upcase
	beq $t2, $0, upword
	
	#whether it is lowcase(a-z)
	sub $t3, $v0, 97
	sub $t4 ,$v0, 122
	slt $s0, $t3, $0
	slt $s1, $0, $t4
	xor $t4, $s0, $s1
	beq $t4, $0, loword
	
	#whether it is num
	sub $t1, $v0, 48
	sub $t2, $v1, 57
	slt $s0, $t1, $0
	slt $s1, $0,  $t2
	xor $t2, $s0, $s1
	beq $t2, $0, tonumber
	j toother
	
upword : sll $t1, $t1, 2 #shift t1 by 2 bits
	la $s0, Upcharoffset #load the address of upcaseoffset into s0
	add $s0, $s0, $t1 #s0 offset (value in t1 register)'s bits of addresses
	lw $s1, ($s0) #load one bit of data from the address of s0 into s1
	la $a0,Upchar
	add $a0, $a0, $s1
	li $v0, 4 #Assign the string address to be printed to the a0 register
	  syscall 
	la $a0, nextline #print \n
	syscall 
	  j main

loword: sll $t3, $t3, 2
	la $s0, lowcharoffset
	add $s0 ,$s0, $t3
	lw $s1, ($s0)
	la $a0,lowchar
	add $a0, $a0, $s1
	li $v0, 4
	syscall 
	la $a0, nextline
	syscall 
	j main
	
tonumber: sll $t1,$t1,2
	la $s0, numberoffset
	add $s0, $s0, $t1
	lw $s1, ($s0)
	la $a0, number
	add $a0, $a0, $s1
	li $v0, 4
	syscall 
	la $a0, nextline
	syscall 
	j main
	
toother: la $a0, other
	li $v0, 4
	syscall 
	la $a0, nextline
	syscall  
	j main
	
	
exit: li $v0, 10
syscall 
	
	
	
	
	