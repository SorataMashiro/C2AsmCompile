
# ---------------------------------------------------------
# Struct Matrix mô ph?ng:
# Offset 0: rows (4 bytes)
# Offset 4: cols (4 bytes)
# Offset 8: data (4 bytes - con tr? ??n m?ng các con tr? hàng)
# ---------------------------------------------------------

.data
    # D? li?u gi? l?p thay cho vi?c ??c file (Input signal)
    input_arr:  .double 1.0, 2.0, 3.0, 4.0, 5.0
    input_size: .word 5
    
    # Các h?ng s? s? th?c dùng ?? test
    val_1_5:    .double 1.5
    val_2_5:    .double 2.5
    val_3_5:    .double 3.5
    
    # Chu?i thông báo
    str_newline: .asciiz "\n"
    str_space:   .asciiz " "
    str_mat_out: .asciiz "Matrix Output:\n"

.text
.globl main

# ---------------------------------------------------------
# Struct Matrix mô ph?ng:
# Offset 0: rows (4 bytes)
# Offset 4: cols (4 bytes)
# Offset 8: data (4 bytes - con tr? ??n m?ng các con tr? hàng)
# ---------------------------------------------------------

main:
    # --- 1. T?o Ma tr?n R (Ví d? 3x3) ---
    li $a0, 3       # rows = 3
    li $a1, 3       # cols = 3
    jal matrix_create
    move $s0, $v0   # L?u ??a ch? Matrix R vào $s0

    # --- 2. ?i?n d? li?u th? nghi?m vào Ma tr?n ---
    # Gán R[0][0] = 1.5
    move $a0, $s0   # Matrix ptr
    li $a1, 0       # row index
    li $a2, 0       # col index
    ldc1 $f0, val_1_5 # [S?A L?I] Thay li.d b?ng ldc1 n?p t? .data
    jal matrix_set

    # Gán R[1][1] = 2.5
    move $a0, $s0
    li $a1, 1
    li $a2, 1
    ldc1 $f0, val_2_5 # [S?A L?I] Thay li.d b?ng ldc1 n?p t? .data
    jal matrix_set

    # Gán R[2][2] = 3.5
    move $a0, $s0
    li $a1, 2
    li $a2, 2
    ldc1 $f0, val_3_5 # [S?A L?I] Thay li.d b?ng ldc1 n?p t? .data
    jal matrix_set

    # --- 3. In Ma tr?n ---
    la $a0, str_mat_out
    li $v0, 4
    syscall

    move $a0, $s0   # Truy?n ??a ch? Matrix R
    jal matrix_print

    # --- 4. K?t thúc ch??ng trình ---
    li $v0, 10
    syscall

# ... (Ph?n còn l?i c?a code: matrix_create, matrix_set, matrix_print gi? nguyên) ...
# ---------------------------------------------------------
# Hàm: matrix_create(int rows, int cols)
# Tr? v?: $v0 = ??a ch? struct Matrix
# ---------------------------------------------------------
matrix_create:
    addi $sp, $sp, -16
    sw $ra, 12($sp)
    sw $s0, 8($sp)  # rows
    sw $s1, 4($sp)  # cols
    sw $s2, 0($sp)  # matrix ptr

    move $s0, $a0
    move $s1, $a1

    # 1. C?p phát struct Matrix (12 bytes: rows, cols, data_ptr)
    li $a0, 12
    li $v0, 9       # Syscall sbrk (malloc)
    syscall
    move $s2, $v0   # L?u ??a ch? struct

    # L?u rows, cols vào struct
    sw $s0, 0($s2)
    sw $s1, 4($s2)

    # 2. C?p phát m?ng các con tr? hàng (rows * 4 bytes)
    mul $a0, $s0, 4 # Kích th??c = rows * 4
    li $v0, 9
    syscall
    sw $v0, 8($s2)  # L?u ??a ch? m?ng con tr? vào struct (offset 8)
    
    # 3. Vòng l?p c?p phát t?ng hàng (m?i hàng = cols * 8 bytes do dùng double)
    lw $t0, 8($s2)  # $t0 = ??a ch? b?t ??u c?a m?ng con tr? hàng
    li $t1, 0       # i = 0
    
    # Tính kích th??c m?t hàng (cols * 8 bytes)
    mul $t2, $s1, 8 

alloc_row_loop:
    bge $t1, $s0, matrix_create_done
    
    # C?p phát hàng i
    move $a0, $t2
    li $v0, 9
    syscall
    
    # L?u ??a ch? hàng v?a c?p phát vào m?ng con tr?
    sw $v0, 0($t0)
    
    addi $t0, $t0, 4 # Tr? ??n ph?n t? ti?p theo trong m?ng con tr?
    addi $t1, $t1, 1 # i++
    j alloc_row_loop

matrix_create_done:
    move $v0, $s2   # Tr? v? ??a ch? struct
    lw $s2, 0($sp)
    lw $s1, 4($sp)
    lw $s0, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# ---------------------------------------------------------
# Hàm: matrix_set(Matrix* m, int r, int c, double val)
# Gán m->data[r][c] = val
# Input: $a0=m, $a1=r, $a2=c, $f0=val (c?p $f0,$f1)
# ---------------------------------------------------------
matrix_set:
    # L?y ??a ch? m?ng các con tr? hàng: m->data
    lw $t0, 8($a0)  
    
    # L?y ??a ch? c?a hàng r: *(m->data + r*4)
    sll $t1, $a1, 2 # r * 4
    add $t1, $t0, $t1
    lw $t2, 0($t1)  # $t2 bây gi? là ??a ch? b?t ??u c?a hàng r

    # L?y ??a ch? c?t c: (hàng r) + c*8
    sll $t3, $a2, 3 # c * 8 (double là 8 bytes)
    add $t3, $t2, $t3

    # L?u giá tr? double vào b? nh?
    sdc1 $f0, 0($t3)
    jr $ra

# ---------------------------------------------------------
# Hàm: matrix_get(Matrix* m, int r, int c)
# Tr? v?: $f0 = m->data[r][c]
# ---------------------------------------------------------
matrix_get:
    # T??ng t? matrix_set nh?ng là load
    lw $t0, 8($a0)
    sll $t1, $a1, 2
    add $t1, $t0, $t1
    lw $t2, 0($t1)
    sll $t3, $a2, 3
    add $t3, $t2, $t3
    ldc1 $f0, 0($t3)
    jr $ra

# ---------------------------------------------------------
# Hàm: matrix_print(Matrix* m)
# In ma tr?n ra console
# ---------------------------------------------------------
matrix_print:
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp) # m
    sw $s1, 8($sp)  # rows
    sw $s2, 4($sp)  # cols
    sw $s3, 0($sp)  # loop counters

    move $s0, $a0
    lw $s1, 0($s0)  # rows
    lw $s2, 4($s0)  # cols

    li $t0, 0       # i = 0 (dùng thanh ghi t?m cho loop ngoài vì jal s? ??i $t)

print_loop_i:
    bge $t0, $s1, print_done
    li $t1, 0       # j = 0

print_loop_j:
    bge $t1, $s2, print_newline

    # G?i matrix_get(m, i, j)
    # C?n l?u $t0, $t1 vì matrix_get không b?o toàn $t
    # ?? ??n gi?n, ta tính tr?c ti?p ??a ch? ? ?ây ?? tránh g?i hàm con (inline)
    
    # Inline logic l?y d? li?u:
    lw $t8, 8($s0)      # data ptr
    sll $t9, $t0, 2     # i * 4
    add $t9, $t8, $t9
    lw $t9, 0($t9)      # row ptr
    sll $t7, $t1, 3     # j * 8
    add $t7, $t9, $t7   # address
    ldc1 $f12, 0($t7)   # Load double vào $f12 ?? in

    # In s? double
    li $v0, 3
    syscall

    # In kho?ng tr?ng
    la $a0, str_space
    li $v0, 4
    syscall

    addi $t1, $t1, 1
    j print_loop_j

print_newline:
    la $a0, str_newline
    li $v0, 4
    syscall
    
    addi $t0, $t0, 1
    j print_loop_i

print_done:
    lw $s3, 0($sp)
    lw $s2, 4($sp)
    lw $s1, 8($sp)
    lw $s0, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    jr $ra