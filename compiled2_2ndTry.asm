.data
    # =========================================================================
    # D? LI?U ??U VÀO (Nhúng tr?c ti?p t? file text b?n g?i)
    # =========================================================================
    .align 3
    # input.txt: -0.6 -4.2 5.6 1.9 1.0 -1.2 -3.0 6.4 5.4 8.3
    input_content:   .double -0.6, -4.2, 5.6, 1.9, 1.0, -1.2, -3.0, 6.4, 5.4, 8.3
    
    .align 3
    # desired.txt: 0.0 3.6 4.6 2.3 -1.0 -2.3 -0.3 3.5 6.3 6.0
    desired_content: .double 0.0, 3.6, 4.6, 2.3, -1.0, -2.3, -0.3, 3.5, 6.3, 6.0

    # =========================================================================
    # CHU?I KÝ T? (Gi? nguyên t? code C)
    # =========================================================================
LC6:    .asciiz  "desired.txt"
LC7:    .asciiz  "input.txt"
LC8:    .asciiz  "Error: size not match\n"
LC9:    .asciiz  "w"
LC10:   .asciiz  "output.txt"
LC11:   .asciiz  "Error: size not match\n"
LC12:   .asciiz  "Error: Cannot solve linear system\n"
LC14:   .asciiz  "Filtered output:"
LC15:   .asciiz  " %9.4f"
LC16:   .asciiz  "MMSE: %.4f\n"
LC0:    .asciiz  "%.6f "
LC2:    .asciiz  "Error: Singular matrix\n"
LC3:    .asciiz  "r"
LC4:    .asciiz  "Error: Cannot open file %s\n"
LC5:    .asciiz  "%lf"
newline:.asciiz  "\n"
LC_MMSE_STR: .asciiz "MMSE: "

    .align 3
CONST_10_0: .double 10.0

.text
.globl main

# =========================================================================
# PH?N 1: MAIN FUNCTION (?ã s?a l?i thoát ch??ng trình)
# =========================================================================
main:
        addiu   $sp,$sp,-136
        sw      $31,132($sp)
        sw      $fp,128($sp)
        sw      $16,124($sp)
        move    $fp,$sp
        
        # G?i read_signal (phiên b?n gi? l?p ??c t? .data)
        addiu   $2,$fp,96
        move    $5,$2
        la      $4,LC6
        jal     read_signal
        nop
        sw      $2,44($fp) # desired ptr

        addiu   $2,$fp,100
        move    $5,$2
        la      $4,LC7
        jal     read_signal
        nop
        sw      $2,48($fp) # input ptr

        # Ki?m tra l?i NULL
        lw      $2,44($fp)
        beq     $2,$0,$L121
        nop
        lw      $2,48($fp)
        beq     $2,$0,$L121
        nop

        # Ki?m tra size (hardcode 10 trong read_signal)
        lw      $3,96($fp)
        li      $2,10
        bne     $3,$2,$L121
        nop
        lw      $3,100($fp)
        li      $2,10
        beq     $3,$2,$L122
        nop

$L121:
        la      $4,LC8
        jal     puts
        nop
        b       $L133
        nop

$L122:
        li      $2,10
        sw      $2,52($fp)      # N
        lw      $2,100($fp)
        sw      $2,56($fp)      # M
        
        # Compute Autocorrelation
        lw      $6,52($fp)
        lw      $5,56($fp)
        lw      $4,48($fp)
        jal     compute_autocorrelation
        nop
        sw      $2,60($fp)      # R

        # Compute Cross Correlation
        addiu   $2,$fp,104
        sw      $2,16($sp)
        lw      $7,52($fp)
        lw      $6,56($fp)
        lw      $5,48($fp)
        lw      $4,44($fp)
        jal     compute_cross_correlation
        nop
        sw      $2,64($fp)      # Gamma

        # Solve Linear System
        addiu   $2,$fp,108
        move    $7,$2
        lw      $6,52($fp)
        lw      $5,64($fp)
        lw      $4,60($fp)
        jal     solve_linear_system
        nop
        sw      $2,68($fp)      # h_opt

        lw      $2,68($fp)
        bne     $2,$0,$L125
        nop

        la      $4,LC12
        jal     puts
        nop
        b       $L133
        nop

$L125:
        # Apply Filter
        addiu   $2,$fp,112
        sw      $2,16($sp)
        lw      $7,52($fp)
        lw      $6,56($fp)
        lw      $5,68($fp)
        lw      $4,48($fp)
        jal     apply_filter
        nop
        sw      $2,72($fp)      # Output

        # Calc MMSE
        lw      $2,100($fp)
        move    $6,$2
        lw      $5,72($fp)
        lw      $4,44($fp)
        jal     calculate_mmse
        nop
        sw      $3,84($fp)      # MMSE HI
        sw      $2,80($fp)      # MMSE LO

        # Rounding Output (x * 10 / 10)
        sw      $0,32($fp)      # i=0
$L126:
        lw      $2,112($fp)     # size
        lw      $3,32($fp)      # i
        slt     $2,$3,$2
        beq     $2,$0,$L_print_start
        nop

        lw      $2,32($fp)
        sll     $2,$2,3
        lw      $3,72($fp)
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        
        la      $4, CONST_10_0
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
        la      $4, CONST_10_0
        lw      $7,4($4)
        lw      $6,0($4)
        jal     __divdf3
        nop
        
        # Store back
        move    $16, $2 # lo
        move    $17, $3 # hi
        lw      $2,32($fp)
        sll     $2,$2,3
        lw      $3,72($fp)
        addu    $16,$3,$2 # re-calc addr? No, reusing reg is risky.
        # Simple store logic:
        lw      $4,32($fp)
        sll     $4,$4,3
        lw      $5,72($fp)
        addu    $4,$5,$4
        sw      $3,4($4)
        sw      $2,0($4)

        lw      $2,32($fp)
        addiu   $2,$2,1
        sw      $2,32($fp)
        b       $L126
        nop

$L_print_start:
    # Print "Filtered output:"
    la      $4, LC14
    jal     puts
    nop

    sw      $0, 36($fp) # i = 0
Print_Loop:
    lw      $2, 112($fp) # size
    lw      $3, 36($fp)  # i
    slt     $2, $3, $2
    beq     $2, $0, $L_print_end
    nop

    # Load output[i]
    lw      $2, 36($fp)
    sll     $2, $2, 3
    lw      $3, 72($fp)  # output array
    addu    $2, $3, $2
    
    # Load double (hard float load)
    ldc1    $f12, 0($2)
    
    # Syscall in s? th?c tr?c ti?p (tránh l?i shim printf)
    li      $v0, 3
    syscall
    
    # In kho?ng tr?ng
    li      $a0, 32      # Space char
    li      $v0, 11
    syscall
    
    # In thêm kho?ng tr?ng n?a cho thoáng
    li      $a0, 32
    li      $v0, 11
    syscall

    # T?ng i
    lw      $2, 36($fp)
    addiu   $2, $2, 1
    sw      $2, 36($fp)
    b       Print_Loop
    nop
    
$L_print_end:
        li      $4,10           # In xu?ng dòng sau m?ng output
        jal     putchar
        nop

        # --- S?A L?I IN MMSE ---
        
        # 1. In chu?i "MMSE: "
        la      $4, LC_MMSE_STR
        li      $v0, 4
        syscall

        # 2. Tính toán làm tròn MMSE (gi? nguyên logic c?)
        lw      $5,84($fp)
        lw      $4,80($fp)
        la      $2, CONST_10_0
        lw      $7,4($2)
        lw      $6,0($2)
        jal     __muldf3
        nop
        move    $5,$3
        move    $4,$2
        jal     round
        nop
        move    $5,$3
        move    $4,$2
        la      $2, CONST_10_0
        lw      $7,4($2)
        lw      $6,0($2)
        jal     __divdf3
        nop

        # 3. In giá tr? MMSE (?ang n?m trong $2 và $3)
        mtc1    $2, $f12        # Chuy?n ph?n th?p vào f12
        mtc1    $3, $f13        # Chuy?n ph?n cao vào f13 (ho?c f12 tùy ch? ??, MARS 32-bit th??ng dùng c?p)
        li      $v0, 3          # Syscall print_double
        syscall

        # 4. In xu?ng dòng cu?i cùng
        la      $4, newline
        li      $v0, 4
        syscall

$L133:
        # [S?A L?I QUAN TR?NG] Thay vì jr $31, dùng Syscall 10 ?? thoát
        li      $v0, 10
        syscall

# =========================================================================
# PH?N 2: SHIM LAYER (Gi? l?p th? vi?n C & Soft Float)
# =========================================================================

# --- Memory Management (Fixed Alignment) ---
malloc:
    # Làm tròn size lên b?i s? c?a 8 ?? tránh l?i alignment v?i ldc1
    addi    $4, $4, 7
    li      $t0, -8
    and     $4, $4, $t0
    li      $v0, 9
    syscall
    jr      $ra
free:
    jr      $ra
memset:
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

# --- I/O ---
printf:
    # Check format string type
    lb      $t0, 0($4)
    li      $t1, '%'
    beq     $t0, $t1, pf_float
    li      $t1, ' '
    beq     $t0, $t1, pf_chk2
    j       pf_str
pf_chk2:
    lb      $t0, 1($4)
    li      $t1, '%'
    beq     $t0, $t1, pf_float
pf_str:
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
    la      $a0, newline
    syscall
    jr      $ra
putchar:
    move    $a0, $4
    li      $v0, 11
    syscall
    jr      $ra
fprintf:
    # Treat as printf for stdout
    move    $4, $5
    move    $5, $6
    move    $6, $7
    # Shift args is tricky, assume simple case or ignore file ptr
    jr      $ra 
fputc:
    jr      $ra
fopen:
    li      $2, 1
    jr      $ra
fclose:
    li      $2, 0
    jr      $ra
fwrite:
    jr      $ra

# --- Replacement for read_signal (Reads from .data) ---
read_signal:
    lb      $t0, 0($4)
    li      $t1, 'i'
    beq     $t0, $t1, rs_inp
    la      $2, desired_content
    j       rs_end
rs_inp:
    la      $2, input_content
rs_end:
    # B? l?nh sw $t0, 0($5) vì $5 không ???c kh?i t?o trong main
    # Main ?ã t? set size = 10 r?i nên không c?n ghi l?i.
    jr      $ra
# --- Math Wrappers (Soft Float $4-$7 to FPU) ---
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

# =========================================================================
# PH?N 3: LOGIC THU?T TOÁN (T? RAW.ASM)
# =========================================================================

matrix_create:
    addiu   $sp, $sp, -48
    sw      $31, 44($sp)
    sw      $fp, 40($sp)
    sw      $s0, 36($sp)
    move    $fp, $sp
    
    sw      $4, 48($fp)     # rows
    sw      $5, 52($fp)     # cols
    
    # Alloc Matrix struct
    li      $4, 16
    jal     malloc
    nop
    move    $s0, $2
    
    # Set rows, cols
    lw      $3, 48($fp)
    sw      $3, 4($s0)
    lw      $3, 52($fp)
    sw      $3, 8($s0)
    
    # Alloc data pointers array
    lw      $4, 48($fp)
    sll     $4, $4, 2       # rows * 4
    jal     malloc
    nop
    sw      $2, 0($s0)      # m->data
    
    # Loop alloc rows
    li      $t0, 0          # i
Loop_MC:
    lw      $3, 48($fp)
    slt     $1, $t0, $3
    beq     $1, $0, End_MC
    
    # Alloc row
    lw      $4, 52($fp)
    sll     $4, $4, 3       # cols * 8
    jal     malloc
    nop
    
    # Store ptr to m->data[i]
    lw      $3, 0($s0)
    sll     $1, $t0, 2
    addu    $1, $3, $1
    sw      $2, 0($1)
    
    # Memset 0
    move    $4, $2
    move    $5, $0
    lw      $6, 52($fp)
    sll     $6, $6, 3
    jal     memset
    nop
    
    addiu   $t0, $t0, 1
    j       Loop_MC
    nop

End_MC:
    move    $2, $s0
    lw      $s0, 36($sp)
    lw      $fp, 40($sp)
    lw      $31, 44($sp)
    addiu   $sp, $sp, 48
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
        lw      $2,48($fp)
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
        # Store
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
        lw      $2,0($4)    # data ptr
        sll     $t0,$5,2
        addu    $t0,$2,$t0  # &data[r1]
        sll     $t1,$6,2
        addu    $t1,$2,$t1  # &data[r2]
        lw      $t2,0($t0)
        lw      $t3,0($t1)
        sw      $t3,0($t0)
        sw      $t2,0($t1)
        jr      $31

compute_autocorrelation:
    addiu   $sp, $sp, -88
    sw      $31, 84($sp)
    sw      $fp, 80($sp)
    sw      $s0, 76($sp)
    sw      $s1, 72($sp)
    sw      $s2, 68($sp)
    sw      $s3, 64($sp)
    sw      $s4, 60($sp)
    move    $fp, $sp
    move    $s0, $4      # x
    move    $s1, $5      # N
    move    $s2, $6      # M

    # R = matrix_create(M, M)
    move    $4, $s2
    move    $5, $s2
    jal     matrix_create
    nop
    move    $s3, $2

    # rxx = malloc(M * 8)
    sll     $4, $s2, 3
    jal     malloc
    nop
    move    $s4, $2

    li      $t0, 0       # k
Loop_AC_K:
    beq     $t0, $s2, Loop_AC_K_End
    mtc1    $0, $f0
    mtc1    $0, $f1      # sum
    move    $t1, $t0     # n
Loop_AC_N:
    slt     $t2, $t1, $s1
    beq     $t2, $0, Loop_AC_N_End
    sll     $t3, $t1, 3
    addu    $t3, $s0, $t3
    ldc1    $f4, 0($t3)  # x[n]
    subu    $t4, $t1, $t0
    sll     $t4, $t4, 3
    addu    $t4, $s0, $t4
    ldc1    $f6, 0($t4)  # x[n-k]
    mul.d   $f4, $f4, $f6
    add.d   $f0, $f0, $f4
    addi    $t1, $t1, 1
    b       Loop_AC_N
    nop
Loop_AC_N_End:
    mtc1    $s1, $f4
    cvt.d.w $f4, $f4
    div.d   $f0, $f0, $f4
    sll     $t3, $t0, 3
    addu    $t3, $s4, $t3
    sdc1    $f0, 0($t3)
    addi    $t0, $t0, 1
    b       Loop_AC_K
    nop
Loop_AC_K_End:

    li      $t0, 0       # i
Loop_Fill_I:
    beq     $t0, $s2, Loop_Fill_I_End
    li      $t1, 0       # j
Loop_Fill_J:
    beq     $t1, $s2, Loop_Fill_J_End
    subu    $t3, $t0, $t1
    bgez    $t3, Abs_Done
    subu    $t3, $0, $t3
Abs_Done:
    sll     $t4, $t3, 3
    addu    $t4, $s4, $t4
    ldc1    $f0, 0($t4)
    lw      $t4, 0($s3)
    sll     $t5, $t0, 2
    addu    $t5, $t4, $t5
    lw      $t5, 0($t5)
    sll     $t6, $t1, 3
    addu    $t6, $t5, $t6
    sdc1    $f0, 0($t6)
    addi    $t1, $t1, 1
    b       Loop_Fill_J
    nop
Loop_Fill_J_End:
    addi    $t0, $t0, 1
    b       Loop_Fill_I
    nop
Loop_Fill_I_End:

    move    $2, $s3
    lw      $s4, 60($sp)
    lw      $s3, 64($sp)
    lw      $s2, 68($sp)
    lw      $s1, 72($sp)
    lw      $s0, 76($sp)
    lw      $fp, 80($sp)
    lw      $31, 84($sp)
    addiu   $sp, $sp, 88
    jr      $31
    nop
    
compute_cross_correlation:
    addiu   $sp, $sp, -80
    sw      $31, 76($sp)
    sw      $fp, 72($sp)
    sw      $s0, 68($sp)
    sw      $s1, 64($sp)
    sw      $s2, 60($sp)
    sw      $s3, 56($sp)
    sw      $s4, 52($sp)
    move    $fp, $sp
    move    $s0, $4 # d
    move    $s1, $5 # x
    move    $s2, $6 # N
    move    $s3, $7 # M
    sll     $4, $s3, 3
    jal     malloc
    nop
    move    $s4, $2
    lw      $t0, 96($sp)
    sw      $s3, 0($t0) # size
    li      $t0, 0
Loop_CC_K:
    beq     $t0, $s3, Loop_CC_K_End
    mtc1    $0, $f0
    mtc1    $0, $f1
    move    $t1, $t0
Loop_CC_N:
    slt     $t2, $t1, $s2
    beq     $t2, $0, Loop_CC_N_End
    sll     $t3, $t1, 3
    addu    $t3, $s0, $t3
    ldc1    $f4, 0($t3)
    subu    $t4, $t1, $t0
    sll     $t4, $t4, 3
    addu    $t4, $s1, $t4
    ldc1    $f6, 0($t4)
    mul.d   $f4, $f4, $f6
    add.d   $f0, $f0, $f4
    addi    $t1, $t1, 1
    b       Loop_CC_N
    nop
Loop_CC_N_End:
    mtc1    $s2, $f4
    cvt.d.w $f4, $f4
    div.d   $f0, $f0, $f4
    sll     $t3, $t0, 3
    addu    $t3, $s4, $t3
    sdc1    $f0, 0($t3)
    addi    $t0, $t0, 1
    b       Loop_CC_K
    nop
Loop_CC_K_End:
    move    $2, $s4
    lw      $s4, 52($sp)
    lw      $s3, 56($sp)
    lw      $s2, 60($sp)
    lw      $s1, 64($sp)
    lw      $s0, 68($sp)
    lw      $fp, 72($sp)
    lw      $31, 76($sp)
    addiu   $sp, $sp, 80
    jr      $31
    nop
    
solve_linear_system:
    addiu   $sp, $sp, -128
    sw      $31, 124($sp)
    sw      $fp, 120($sp)
    sw      $s0, 116($sp)
    sw      $s1, 112($sp)
    sw      $s2, 108($sp)
    sw      $s3, 104($sp)
    sw      $s4, 100($sp)
    sw      $s5, 96($sp)
    move    $fp, $sp
    sw      $7, 140($sp) # size ptr
    move    $s2, $6 # n
    jal     matrix_copy
    nop
    move    $s0, $2
    sll     $4, $s2, 3
    jal     malloc
    nop
    move    $s1, $2
    move    $4, $s1
    lw      $5, 132($fp)
    sll     $6, $s2, 3
    jal     memcpy
    nop
    li      $s4, 0
Loop_P:
    beq     $s4, $s2, Loop_P_End
    addi    $s5, $s4, 1
Loop_I:
    slt     $t0, $s5, $s2
    beq     $t0, $0, Loop_I_End
    lw      $t0, 0($s0)
    sll     $t1, $s5, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $s4, 3
    addu    $t2, $t1, $t2
    ldc1    $f4, 0($t2)
    lw      $t0, 0($s0)
    sll     $t1, $s4, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $s4, 3
    addu    $t2, $t1, $t2
    ldc1    $f6, 0($t2)
    div.d   $f8, $f4, $f6
    sll     $t0, $s4, 3
    addu    $t0, $s1, $t0
    ldc1    $f10, 0($t0)
    mul.d   $f10, $f10, $f8
    sll     $t0, $s5, 3
    addu    $t0, $s1, $t0
    ldc1    $f16, 0($t0)
    sub.d   $f16, $f16, $f10
    sdc1    $f16, 0($t0)
    move    $t8, $s4
Loop_J:
    slt     $t0, $t8, $s2
    beq     $t0, $0, Loop_J_End
    lw      $t0, 0($s0)
    sll     $t1, $s4, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $t8, 3
    addu    $t2, $t1, $t2
    ldc1    $f10, 0($t2)
    mul.d   $f10, $f10, $f8
    lw      $t0, 0($s0)
    sll     $t1, $s5, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $t8, 3
    addu    $t2, $t1, $t2
    ldc1    $f16, 0($t2)
    sub.d   $f16, $f16, $f10
    sdc1    $f16, 0($t2)
    addi    $t8, $t8, 1
    b       Loop_J
    nop
Loop_J_End:
    addi    $s5, $s5, 1
    b       Loop_I
    nop
Loop_I_End:
    addi    $s4, $s4, 1
    b       Loop_P
    nop
Loop_P_End:
    sll     $4, $s2, 3
    jal     malloc
    nop
    move    $s3, $2
    addi    $s4, $s2, -1
Loop_Back_I:
    bltz    $s4, Loop_Back_End
    mtc1    $0, $f0
    mtc1    $0, $f1
    addi    $s5, $s4, 1
Loop_Back_J:
    slt     $t0, $s5, $s2
    beq     $t0, $0, Loop_Back_J_End
    lw      $t0, 0($s0)
    sll     $t1, $s4, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $s5, 3
    addu    $t2, $t1, $t2
    ldc1    $f4, 0($t2)
    sll     $t0, $s5, 3
    addu    $t0, $s3, $t0
    ldc1    $f6, 0($t0)
    mul.d   $f4, $f4, $f6
    add.d   $f0, $f0, $f4
    addi    $s5, $s5, 1
    b       Loop_Back_J
    nop
Loop_Back_J_End:
    sll     $t0, $s4, 3
    addu    $t0, $s1, $t0
    ldc1    $f4, 0($t0)
    sub.d   $f4, $f4, $f0
    lw      $t0, 0($s0)
    sll     $t1, $s4, 2
    addu    $t1, $t0, $t1
    lw      $t1, 0($t1)
    sll     $t2, $s4, 3
    addu    $t2, $t1, $t2
    ldc1    $f6, 0($t2)
    div.d   $f4, $f4, $f6
    sll     $t0, $s4, 3
    addu    $t0, $s3, $t0
    sdc1    $f4, 0($t0)
    addi    $s4, $s4, -1
    b       Loop_Back_I
    nop
Loop_Back_End:
    lw      $t0, 140($sp)
    sw      $s2, 0($t0)
    move    $2, $s3
    lw      $s5, 96($sp)
    lw      $s4, 100($sp)
    lw      $s3, 104($sp)
    lw      $s2, 108($sp)
    lw      $s1, 112($sp)
    lw      $s0, 116($sp)
    lw      $fp, 120($sp)
    lw      $31, 124($sp)
    addiu   $sp, $sp, 128
    jr      $31
    nop
    
apply_filter:
    addiu   $sp, $sp, -80
    sw      $31, 76($sp)
    sw      $fp, 72($sp)
    sw      $s0, 68($sp)
    sw      $s1, 64($sp)
    sw      $s2, 60($sp)
    sw      $s3, 56($sp)
    sw      $s4, 52($sp)
    move    $fp, $sp
    move    $s0, $4 # x
    move    $s1, $5 # h
    move    $s2, $6 # N
    move    $s3, $7 # M
    sll     $4, $s2, 3
    jal     malloc
    nop
    move    $s4, $2
    lw      $t0, 96($sp)
    sw      $s2, 0($t0)
    li      $t0, 0
Loop_AF_N:
    beq     $t0, $s2, Loop_AF_N_End
    mtc1    $0, $f0
    mtc1    $0, $f1
    li      $t1, 0
Loop_AF_K:
    beq     $t1, $s3, Loop_AF_K_End
    subu    $t2, $t0, $t1
    bltz    $t2, Skip_AF
    slt     $t3, $t2, $s2
    beq     $t3, $0, Skip_AF
    sll     $t4, $t1, 3
    addu    $t4, $s1, $t4
    ldc1    $f4, 0($t4)
    sll     $t5, $t2, 3
    addu    $t5, $s0, $t5
    ldc1    $f6, 0($t5)
    mul.d   $f4, $f4, $f6
    add.d   $f0, $f0, $f4
Skip_AF:
    addi    $t1, $t1, 1
    b       Loop_AF_K
    nop
Loop_AF_K_End:
    sll     $t4, $t0, 3
    addu    $t4, $s4, $t4
    sdc1    $f0, 0($t4)
    addi    $t0, $t0, 1
    b       Loop_AF_N
    nop
Loop_AF_N_End:
    move    $2, $s4
    lw      $s4, 52($sp)
    lw      $s3, 56($sp)
    lw      $s2, 60($sp)
    lw      $s1, 64($sp)
    lw      $s0, 68($sp)
    lw      $fp, 72($sp)
    lw      $31, 76($sp)
    addiu   $sp, $sp, 80
    jr      $31
    nop
    
calculate_mmse:
    addiu   $sp, $sp, -64
    sw      $31, 60($sp)
    sw      $fp, 56($sp)
    sw      $s0, 52($sp)
    sw      $s1, 48($sp)
    sw      $s2, 44($sp)
    move    $fp, $sp
    move    $s0, $4 # desired
    move    $s1, $5 # output
    move    $s2, $6 # size
    mtc1    $0, $f0
    mtc1    $0, $f1
    li      $t0, 0
Loop_MMSE:
    beq     $t0, $s2, Loop_MMSE_End
    sll     $t1, $t0, 3
    addu    $t2, $s0, $t1
    ldc1    $f4, 0($t2)
    addu    $t2, $s1, $t1
    ldc1    $f6, 0($t2)
    sub.d   $f4, $f4, $f6
    mul.d   $f4, $f4, $f4
    add.d   $f0, $f0, $f4
    addi    $t0, $t0, 1
    b       Loop_MMSE
    nop
Loop_MMSE_End:
    mtc1    $s2, $f4
    cvt.d.w $f4, $f4
    div.d   $f0, $f0, $f4
    mfc1    $2, $f0
    mfc1    $3, $f1
    lw      $s2, 44($sp)
    lw      $s1, 48($sp)
    lw      $s0, 52($sp)
    lw      $fp, 56($sp)
    lw      $31, 60($sp)
    addiu   $sp, $sp, 64
    jr      $31
    nop