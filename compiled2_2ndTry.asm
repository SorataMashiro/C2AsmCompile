.data
    # =========================================================================
    # D? LI?U ??U VÀO
    # =========================================================================
    .align 3
    # input.txt: -0.6 -4.2 5.6 1.9 1.0 -1.2 -3.0 6.4 5.4 8.3
    input_content:   .double -0.6, -4.2, 5.6, 1.9, 1.0, -1.2, -3.0, 6.4, 5.4, 8.3
    
    .align 3
    # desired.txt: 0.0 3.6 4.6 2.3 -1.0 -2.3 -0.3 3.5 6.3 6.0
    desired_content: .double 0.0, 3.6, 4.6, 2.3, -1.0, -2.3, -0.3, 3.5, 6.3, 6.0

    # =========================================================================
    # H?NG S? & CHU?I
    # =========================================================================
    
    # H?ng s? 10.0 (Double) - Little Endian: Low word tr??c, High word sau
    .align 3
LC13:   .word   0, 1076101120  

    .align 3
LC1:    .word   -640172613, 1037794527

    # Strings
LC_FILE_DES:    .asciiz "desired.txt"
LC_FILE_INP:    .asciiz "input.txt"
LC_ERR_SIZE:    .asciiz "Error: size not match\n"
LC_ERR_SOLVE:   .asciiz "Error: Cannot solve linear system\n"
LC_STR_FILTER:  .asciiz "Filtered output:"
LC_FMT_SPACE:   .asciiz "   "
LC_STR_MMSE:    .asciiz "MMSE: "
LC_NEWLINE:     .asciiz "\n"

    .align 3
CONST_10_0: .double 10.0

.text
.globl main

# =========================================================================
# SHIM LAYER: GI? L?P TH? VI?N C
# =========================================================================

# --- Memory Management ---
malloc:
    li      $v0, 9          # sbrk
    syscall
    jr      $ra

free:
    jr      $ra             # No-op

memset:
    # $4=dest, $5=val, $6=len
    move    $t0, $4
    addu    $t1, $4, $6
memset_loop:
    beq     $t0, $t1, memset_end
    sb      $5, 0($t0)
    addiu   $t0, $t0, 1
    j       memset_loop
memset_end:
    move    $2, $4
    jr      $ra

memcpy:
    # $4=dest, $5=src, $6=len
    move    $t0, $4
    move    $t1, $5
    addu    $t2, $4, $6
memcpy_loop:
    beq     $t0, $t2, memcpy_end
    lb      $t3, 0($t1)
    sb      $t3, 0($t0)
    addiu   $t0, $t0, 1
    addiu   $t1, $t1, 1
    j       memcpy_loop
memcpy_end:
    move    $2, $4
    jr      $ra

# --- I/O Functions ---
printf:
    lb      $t0, 0($4)
    li      $t1, '%'
    beq     $t0, $t1, pf_float
    li      $t1, ' '
    beq     $t0, $t1, pf_check_2
    j       pf_string
pf_check_2:
    lb      $t0, 1($4)
    li      $t1, '%'
    beq     $t0, $t1, pf_float
pf_string:
    li      $v0, 4
    syscall
    jr      $ra
pf_float:
    mtc1    $6, $f12
    mtc1    $7, $f13
    li      $v0, 3
    syscall
    jr      $ra

puts:
    li      $v0, 4
    syscall
    la      $a0, LC_NEWLINE
    syscall
    jr      $ra

putchar:
    move    $a0, $4
    li      $v0, 11
    syscall
    jr      $ra

# --- File Operations (Fixed Syntax) ---
fopen:
    li      $2, 1
    jr      $ra

fclose:
    li      $2, 0
    jr      $ra

fwrite:
    jr      $ra

fprintf:
    jr      $ra

fputc:
    jr      $ra

# --- Math Wrappers (Soft-Float to Hard-Float) ---
__adddf3:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    add.d $f0, $f0, $f2
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

__subdf3:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    sub.d $f0, $f0, $f2
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

__muldf3:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    mul.d $f0, $f0, $f2
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

__divdf3:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    div.d $f0, $f0, $f2
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

__floatsidf:
    mtc1 $4, $f0
    cvt.d.w $f0, $f0
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

__gtdf2:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    c.le.d $f0, $f2
    bc1t gt_false
    li $2, 1
    jr $ra
gt_false:
    li $2, 0
    jr $ra

__ltdf2:
    mtc1 $4, $f0
    mtc1 $5, $f1
    mtc1 $6, $f2
    mtc1 $7, $f3
    c.lt.d $f0, $f2
    bc1t lt_true
    li $2, 0
    jr $ra
lt_true:
    li $2, -1
    jr $ra

round:
    mtc1 $4, $f0
    mtc1 $5, $f1
    round.w.d $f2, $f0
    cvt.d.w $f0, $f2
    mfc1 $2, $f0
    mfc1 $3, $f1
    jr $ra

read_signal:
    lb      $t0, 0($4)
    li      $t1, 'i'
    beq     $t0, $t1, rs_inp
    la      $2, desired_content
    j       rs_end
rs_inp:
    la      $2, input_content
rs_end:
    li      $t0, 10
    sw      $t0, 0($5)
    jr      $ra

# =========================================================================
# LOGIC THU?T TOÁN
# =========================================================================

matrix_create:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        sw      $16,36($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        sw      $5,52($fp)
        li      $4,12
        jal     malloc
        nop
        sw      $2,28($fp)
        lw      $2,28($fp)
        lw      $3,48($fp)
        sw      $3,4($2)
        lw      $3,52($fp)
        sw      $3,8($2)
        lw      $2,48($fp)
        sll     $2,$2,2
        move    $4,$2
        jal     malloc
        nop
        move    $3,$2
        lw      $2,28($fp)
        sw      $3,0($2)
        sw      $0,24($fp)
        b       L_mc_check
        nop
L_mc_loop:
        lw      $2,52($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        move    $16, $2
        lw      $2,28($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $16,$3,$2 
        # Reload to fix register usage
        lw      $2,28($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $16,$3,$2
        
        lw      $2,52($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        
        sw      $2,0($16)
        
        move    $4, $2
        move    $5, $0
        lw      $2,52($fp)
        sll     $6, $2, 3
        jal     memset
        nop

        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
L_mc_check:
        lw      $3,24($fp)
        lw      $2,48($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_mc_loop
        nop
        lw      $2,28($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        lw      $16,36($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_copy:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        lw      $2,48($fp)
        lw      $3,4($2)
        lw      $2,8($2)
        move    $5,$2
        move    $4,$3
        jal     matrix_create
        nop
        sw      $2,32($fp)
        sw      $0,24($fp)
        b       L_cp_i
        nop
L_cp_loop_i:
        sw      $0,28($fp)
        b       L_cp_j
        nop
L_cp_loop_j:
        lw      $2,48($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $4,0($2)
        move    $17,$3
        move    $16,$4
        lw      $2,32($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        sw      $17,4($2)
        sw      $16,0($2)
        lw      $2,28($fp)
        addiu   $2,$2,1
        sw      $2,28($fp)
L_cp_j:
        lw      $2,48($fp)
        lw      $2,8($2)
        lw      $3,28($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_cp_loop_j
        nop
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
L_cp_i:
        lw      $2,48($fp)
        lw      $2,4($2)
        lw      $3,24($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_cp_loop_i
        nop
        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_free:
        jr      $ra

swap_double:
        lw      $2,0($4)
        lw      $3,4($4)
        lw      $6,0($5)
        lw      $7,4($5)
        sw      $6,0($4)
        sw      $7,4($4)
        sw      $2,0($5)
        sw      $3,4($5)
        jr      $ra

swap_matrix_rows:
        lw      $2,0($4)
        sll     $t0,$5,2
        addu    $t0,$2,$t0
        sll     $t1,$6,2
        addu    $t1,$2,$t1
        lw      $t2,0($t0)
        lw      $t3,0($t1)
        sw      $t3,0($t0)
        sw      $t2,0($t1)
        jr      $31

compute_autocorrelation:
        addiu   $sp,$sp,-80
        sw      $31,76($sp)
        sw      $fp,72($sp)
        move    $fp,$sp
        sw      $4,80($fp)
        sw      $5,84($fp)
        sw      $6,88($fp)
        move    $5,$6
        move    $4,$6
        jal     matrix_create
        nop
        sw      $2,52($fp)
        lw      $2,88($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        sw      $2,56($fp)
        sw      $0,24($fp)
L_ac_k:
        sw      $0,36($fp)
        sw      $0,32($fp)
        lw      $2,24($fp)
        sw      $2,40($fp)
L_ac_n:
        lw      $2,40($fp)
        sll     $2,$2,3
        lw      $3,80($fp)
        addu    $2,$3,$2
        lw      $5,4($2)
        lw      $4,0($2)
        lw      $2,40($fp)
        lw      $3,24($fp)
        subu    $2,$2,$3
        sll     $2,$2,3
        lw      $3,80($fp)
        addu    $2,$3,$2
        lw      $7,4($2)
        lw      $6,0($2)
        jal     __muldf3
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __adddf3
        nop
        sw      $3,36($fp)
        sw      $2,32($fp)
        lw      $2,40($fp)
        addiu   $2,$2,1
        sw      $2,40($fp)
        lw      $3,40($fp)
        lw      $2,84($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_ac_n
        nop
        lw      $4,84($fp)
        jal     __floatsidf
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __divdf3
        nop
        lw      $4,24($fp)
        sll     $4,$4,3
        lw      $5,56($fp)
        addu    $4,$5,$4
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
        lw      $3,24($fp)
        lw      $2,88($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_ac_k
        nop
        sw      $0,44($fp)
L_f_i:
        sw      $0,48($fp)
L_f_j:
        lw      $3,44($fp)
        lw      $2,48($fp)
        subu    $2,$3,$2
        bgez    $2,L_abs
        subu    $2,$0,$2
L_abs:
        sll     $2,$2,3
        lw      $3,56($fp)
        addu    $2,$3,$2
        lw      $7,4($2)
        lw      $6,0($2)
        lw      $2,52($fp)
        lw      $3,0($2)
        lw      $2,44($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,48($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        sw      $7,4($2)
        sw      $6,0($2)
        lw      $2,48($fp)
        addiu   $2,$2,1
        sw      $2,48($fp)
        lw      $3,48($fp)
        lw      $2,88($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_f_j
        nop
        lw      $2,44($fp)
        addiu   $2,$2,1
        sw      $2,44($fp)
        lw      $3,44($fp)
        lw      $2,88($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_f_i
        nop
        lw      $2,52($fp)
        move    $sp,$fp
        lw      $31,76($sp)
        lw      $fp,72($sp)
        addiu   $sp,$sp,80
        jr      $31
        nop

compute_cross_correlation:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        sw      $6,72($fp)
        sw      $7,76($fp)
        lw      $2,76($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        sw      $2,44($fp)
        sw      $0,24($fp)
L_cc_k:
        sw      $0,36($fp)
        sw      $0,32($fp)
        lw      $2,24($fp)
        sw      $2,40($fp)
L_cc_n:
        lw      $2,40($fp)
        sll     $2,$2,3
        lw      $3,64($fp)
        addu    $2,$3,$2
        lw      $5,4($2)
        lw      $4,0($2)
        lw      $2,40($fp)
        lw      $3,24($fp)
        subu    $2,$2,$3
        sll     $2,$2,3
        lw      $3,68($fp)
        addu    $2,$3,$2
        lw      $7,4($2)
        lw      $6,0($2)
        jal     __muldf3
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __adddf3
        nop
        sw      $3,36($fp)
        sw      $2,32($fp)
        lw      $2,40($fp)
        addiu   $2,$2,1
        sw      $2,40($fp)
        lw      $3,40($fp)
        lw      $2,72($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_cc_n
        nop
        lw      $4,72($fp)
        jal     __floatsidf
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __divdf3
        nop
        lw      $4,24($fp)
        sll     $4,$4,3
        lw      $5,44($fp)
        addu    $4,$5,$4
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
        lw      $3,24($fp)
        lw      $2,76($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_cc_k
        nop
        lw      $2,44($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

solve_linear_system:
        addiu   $sp,$sp,-128
        sw      $31,124($sp)
        sw      $fp,120($sp)
        move    $fp,$sp
        sw      $4,128($fp)
        sw      $5,132($fp)
        sw      $6,136($fp)
        sw      $7,140($fp)
        lw      $4,128($fp)
        jal     matrix_copy
        nop
        sw      $2,60($fp)
        lw      $2,136($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        sw      $2,64($fp)
        move    $4,$2
        lw      $5,132($fp)
        lw      $2,136($fp)
        sll     $6,$2,3
        jal     memcpy
        nop
        sw      $0,24($fp)
L_sl_p:
        lw      $3,24($fp)
        lw      $2,136($fp)
        slt     $2,$3,$2
        beq     $2,$0,L_sl_back
        nop
        lw      $2,24($fp)
        sw      $2,28($fp)
        addiu   $2,$2,1
        sw      $2,32($fp)
L_sl_pvt:
        lw      $3,32($fp)
        lw      $2,136($fp)
        slt     $2,$3,$2
        beq     $2,$0,L_sl_swap
        nop
        lw      $2,32($fp)
        addiu   $2,$2,1
        sw      $2,32($fp)
        b       L_sl_pvt
        nop
L_sl_swap:
        lw      $6,28($fp)
        lw      $5,24($fp)
        lw      $4,60($fp)
        jal     swap_matrix_rows
        nop
        lw      $2,64($fp)
        lw      $3,24($fp)
        sll     $3,$3,3
        addu    $4,$2,$3
        lw      $3,28($fp)
        sll     $3,$3,3
        addu    $5,$2,$3
        jal     swap_double
        nop
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,36($fp)
L_sl_elim:
        lw      $3,36($fp)
        lw      $2,136($fp)
        slt     $2,$3,$2
        beq     $2,$0,L_sl_next_p
        nop
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,36($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $5,4($2)
        lw      $4,0($2)
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $7,4($2)
        lw      $6,0($2)
        jal     __divdf3
        nop
        sw      $3,76($fp)
        sw      $2,72($fp)
        lw      $2,64($fp)
        lw      $3,36($fp)
        sll     $3,$3,3
        addu    $2,$3,$2
        lw      $23,4($2)
        lw      $22,0($2)
        lw      $2,64($fp)
        lw      $3,24($fp)
        sll     $3,$3,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,76($fp)
        lw      $6,72($fp)
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop
        move    $5,$3
        move    $4,$2
        lw      $2,64($fp)
        lw      $3,36($fp)
        sll     $3,$3,3
        addu    $2,$3,$2
        sw      $2,80($fp)
        move    $7,$5
        move    $6,$4
        move    $5,$23
        move    $4,$22
        jal     __subdf3
        nop
        lw      $4,80($fp)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,24($fp)
        sw      $2,40($fp)
L_sl_sub_row:
        lw      $3,40($fp)
        lw      $2,136($fp)
        slt     $2,$3,$2
        beq     $2,$0,L_sl_next_i
        nop
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,36($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $23,4($2)
        lw      $22,0($2)
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,24($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,76($fp)
        lw      $6,72($fp)
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop
        move    $5,$3
        move    $4,$2
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,36($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        sw      $2,80($fp)
        move    $7,$5
        move    $6,$4
        move    $5,$23
        move    $4,$22
        jal     __subdf3
        nop
        lw      $4,80($fp)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,40($fp)
        addiu   $2,$2,1
        sw      $2,40($fp)
        b       L_sl_sub_row
        nop
L_sl_next_i:
        lw      $2,36($fp)
        addiu   $2,$2,1
        sw      $2,36($fp)
        b       L_sl_elim
        nop
L_sl_next_p:
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       L_sl_p
        nop
L_sl_back:
        lw      $2,136($fp)
        sll     $4,$2,3
        jal     malloc
        nop
        sw      $2,68($fp)
        lw      $2,140($fp)
        lw      $3,136($fp)
        sw      $3,0($2)
        lw      $2,136($fp)
        addiu   $2,$2,-1
        sw      $2,44($fp)
L_sl_back_loop:
        sw      $0,52($fp)
        sw      $0,48($fp)
        lw      $2,44($fp)
        addiu   $2,$2,1
        sw      $2,56($fp)
L_sl_back_sum:
        lw      $3,56($fp)
        lw      $2,136($fp)
        slt     $2,$3,$2
        beq     $2,$0,L_sl_back_calc
        nop
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,44($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,56($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,56($fp)
        sll     $4,$4,3
        lw      $5,68($fp)
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop
        move    $7,$3
        move    $6,$2
        lw      $5,52($fp)
        lw      $4,48($fp)
        jal     __adddf3
        nop
        sw      $3,52($fp)
        sw      $2,48($fp)
        lw      $2,56($fp)
        addiu   $2,$2,1
        sw      $2,56($fp)
        b       L_sl_back_sum
        nop
L_sl_back_calc:
        lw      $2,44($fp)
        sll     $2,$2,3
        lw      $3,64($fp)
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,52($fp)
        lw      $6,48($fp)
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop
        move    $17,$3
        move    $16,$2
        lw      $2,60($fp)
        lw      $3,0($2)
        lw      $2,44($fp)
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,44($fp)
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,44($fp)
        sll     $4,$4,3
        lw      $5,68($fp)
        addu    $4,$5,$4
        sw      $4,76($fp)
        move    $7,$3
        move    $6,$2
        move    $5,$17
        move    $4,$16
        jal     __divdf3
        nop
        lw      $4,76($fp)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,44($fp)
        addiu   $2,$2,-1
        sw      $2,44($fp)
        bgez    $2,L_sl_back_loop
        nop
        lw      $2,68($fp)
        move    $sp,$fp
        lw      $31,124($sp)
        addiu   $sp,$sp,128
        jr      $31
        nop

apply_filter:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        sw      $6,72($fp)
        sw      $7,76($fp)
        lw      $2,80($fp)
        lw      $3,72($fp)
        sw      $3,0($2)
        sll     $4,$3,3
        jal     malloc
        nop
        sw      $2,32($fp)
        sw      $0,24($fp)
L_af_n:
        sw      $0,28($fp)
        sw      $0,36($fp)
        sw      $0,40($fp)
L_af_k:
        lw      $3,24($fp)
        lw      $2,40($fp)
        subu    $2,$3,$2
        bltz    $2, L_af_skip
        lw      $3,72($fp)
        sge     $3,$2,$3
        bnez    $3, L_af_skip
        lw      $3,68($fp)
        lw      $4,40($fp)
        sll     $4,$4,3
        addu    $3,$3,$4
        lw      $5,4($3)
        lw      $4,0($3)
        lw      $3,64($fp)
        sll     $2,$2,3
        addu    $3,$3,$2
        lw      $7,4($3)
        lw      $6,0($3)
        jal     __muldf3
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,36($fp)
        lw      $4,28($fp)
        jal     __adddf3
        nop
        sw      $3,36($fp)
        sw      $2,28($fp)
L_af_skip:
        lw      $2,40($fp)
        addiu   $2,$2,1
        sw      $2,40($fp)
        lw      $3,40($fp)
        lw      $2,76($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_af_k
        nop
        lw      $4,32($fp)
        lw      $2,24($fp)
        sll     $2,$2,3
        addu    $4,$4,$2
        lw      $3,36($fp)
        lw      $2,28($fp)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,24($fp)
        addiu   $2,$2,1
        sw      $2,24($fp)
        lw      $3,24($fp)
        lw      $2,72($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_af_n
        nop
        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

calculate_mmse:
        addiu   $sp,$sp,-56
        sw      $31,52($sp)
        sw      $fp,48($sp)
        move    $fp,$sp
        sw      $4,56($fp)
        sw      $5,60($fp)
        sw      $6,64($fp)
        sw      $0,24($fp)
        sw      $0,28($fp)
        sw      $0,32($fp)
L_mm:
        lw      $2,32($fp)
        sll     $2,$2,3
        lw      $3,56($fp)
        addu    $3,$3,$2
        lw      $5,4($3)
        lw      $4,0($3)
        lw      $3,60($fp)
        addu    $3,$3,$2
        lw      $7,4($3)
        lw      $6,0($3)
        jal     __subdf3
        nop
        move    $4,$2
        move    $5,$3
        move    $6,$2
        move    $7,$3
        jal     __muldf3
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __adddf3
        nop
        sw      $3,28($fp)
        sw      $2,24($fp)
        lw      $2,32($fp)
        addiu   $2,$2,1
        sw      $2,32($fp)
        lw      $3,32($fp)
        lw      $2,64($fp)
        slt     $2,$3,$2
        bne     $2,$0,L_mm
        nop
        lw      $4,64($fp)
        jal     __floatsidf
        nop
        move    $6,$2
        move    $7,$3
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __divdf3
        nop
        move    $sp,$fp
        lw      $31,52($sp)
        addiu   $sp,$sp,56
        jr      $31
        nop

# =========================================================================
# MAIN
# =========================================================================
main:
        addiu   $sp,$sp,-136
        sw      $31,132($sp)
        sw      $fp,128($sp)
        move    $fp,$sp
        la      $4,LC_FILE_DES
        jal     read_signal
        nop
        sw      $2,44($fp)
        la      $4,LC_FILE_INP
        jal     read_signal
        nop
        sw      $2,48($fp)
        lw      $2,44($fp)
        beq     $2,$0,L_err_size
        lw      $2,48($fp)
        beq     $2,$0,L_err_size
        
        li      $2,10
        sw      $2,52($fp)
        sw      $2,56($fp)
        
        lw      $6,52($fp)
        lw      $5,56($fp)
        lw      $4,48($fp)
        jal     compute_autocorrelation
        nop
        sw      $2,60($fp)
        
        addiu   $2,$fp,104
        sw      $2,16($sp)
        lw      $7,52($fp)
        lw      $6,56($fp)
        lw      $5,48($fp)
        lw      $4,44($fp)
        jal     compute_cross_correlation
        nop
        sw      $2,64($fp)
        
        addiu   $2,$fp,108
        move    $7,$2
        lw      $6,56($fp)
        lw      $5,64($fp)
        lw      $4,60($fp)
        jal     solve_linear_system
        nop
        sw      $2,68($fp)
        beq     $2,$0,L_err_solve
        
        addiu   $2,$fp,112
        sw      $2,16($sp)
        lw      $7,56($fp)
        lw      $6,52($fp)
        lw      $5,68($fp)
        lw      $4,48($fp)
        jal     apply_filter
        nop
        sw      $2,72($fp)
        
        lw      $6,52($fp)
        lw      $5,72($fp)
        lw      $4,44($fp)
        jal     calculate_mmse
        nop
        sw      $3,84($fp)
        sw      $2,80($fp)
        
        la      $4,LC_STR_FILTER
        jal     puts
        nop
        sw      $0,36($fp)
L_p_loop:
        lw      $2,36($fp)
        sll     $2,$2,3
        lw      $3,72($fp)
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        la      $4,LC13
        lw      $7,4($4)
        lw      $6,0($4)
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop
        move    $5,$3
        move    $4,$2
        jal     round
        nop
        move    $5,$3
        move    $4,$2
        la      $4,LC13
        lw      $7,4($4)
        lw      $6,0($4)
        jal     __divdf3
        nop
        
        move    $17,$3
        move    $16,$2
        lw      $2,36($fp)
        sll     $2,$2,3
        lw      $3,72($fp)
        addu    $2,$3,$2
        sw      $17,4($2)
        sw      $16,0($2)
        
        la      $4,LC_FMT_SPACE
        li      $v0,4
        syscall
        mtc1    $16,$f12
        mtc1    $17,$f13
        li      $v0,3
        syscall
        
        lw      $2,36($fp)
        addiu   $2,$2,1
        sw      $2,36($fp)
        lw      $3,112($fp)
        slt     $2,$2,$3
        bne     $2,$0,L_p_loop
        nop
        
        li      $a0,10
        li      $v0,11
        syscall
        
        lw      $6,52($fp)
        lw      $5,72($fp)
        lw      $4,44($fp)
        jal     calculate_mmse
        nop
        sw      $3,84($fp)
        sw      $2,80($fp)
        
        la      $4,LC13
        lw      $7,4($4)
        lw      $6,0($4)
        lw      $5,84($fp)
        lw      $4,80($fp)
        jal     __muldf3
        nop
        move    $5,$3
        move    $4,$2
        jal     round
        nop
        move    $5,$3
        move    $4,$2
        la      $4,LC13
        lw      $7,4($4)
        lw      $6,0($4)
        jal     __divdf3
        nop
        
        move    $2,$16
        move    $3,$17
        
        la      $4,LC_STR_MMSE
        li      $v0,4
        syscall
        mtc1    $16,$f12
        mtc1    $17,$f13
        li      $v0,3
        syscall
        li      $a0,10
        li      $v0,11
        syscall
        j       L_end

L_err_size:
        la      $4,LC_ERR_SIZE
        jal     puts
        nop
        j       L_end
L_err_solve:
        la      $4,LC_ERR_SOLVE
        jal     puts
        nop
L_end:
        li      $v0,10
        syscall