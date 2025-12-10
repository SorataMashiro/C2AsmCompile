matrix_create:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        sw      $16,36($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        sw      $5,52($fp)
        li      $4,12                 # 0xc
        jal     malloc
        nop

        sw      $2,28($fp)
        lw      $2,28($fp)
        lw      $3,48($fp)
        nop
        sw      $3,4($2)
        lw      $2,28($fp)
        lw      $3,52($fp)
        nop
        sw      $3,8($2)
        lw      $2,48($fp)
        nop
        sll     $2,$2,2
        move    $4,$2
        jal     malloc
        nop

        move    $3,$2
        lw      $2,28($fp)
        nop
        sw      $3,0($2)
        sw      $0,24($fp)
        b       $L2
        nop

$L3:
        lw      $2,52($fp)
        nop
        sll     $4,$2,3
        lw      $2,28($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $16,$3,$2
        jal     malloc
        nop

        sw      $2,0($16)
        lw      $2,28($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,52($fp)
        nop
        sll     $2,$2,3
        move    $6,$2
        move    $5,$0
        move    $4,$3
        jal     memset
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L2:
        lw      $3,24($fp)
        lw      $2,48($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L3
        nop

        lw      $2,28($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        lw      $16,36($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_free:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        lw      $2,40($fp)
        nop
        beq     $2,$0,$L9
        nop

        sw      $0,24($fp)
        b       $L7
        nop

$L8:
        lw      $2,40($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $2,0($2)
        nop
        move    $4,$2
        jal     free
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L7:
        lw      $2,40($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L8
        nop

        lw      $2,40($fp)
        nop
        lw      $2,0($2)
        nop
        move    $4,$2
        jal     free
        nop

        lw      $4,40($fp)
        jal     free
        nop

$L9:
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $31
        nop

matrix_copy:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        lw      $2,48($fp)
        nop
        lw      $3,4($2)
        lw      $2,48($fp)
        nop
        lw      $2,8($2)
        nop
        move    $5,$2
        move    $4,$3
        jal     matrix_create
        nop

        sw      $2,32($fp)
        sw      $0,24($fp)
        b       $L11
        nop

$L14:
        sw      $0,28($fp)
        b       $L12
        nop

$L13:
        lw      $2,48($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,32($fp)
        nop
        lw      $4,0($3)
        lw      $3,24($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $4,0($3)
        lw      $3,28($fp)
        nop
        sll     $3,$3,3
        addu    $4,$4,$3
        lw      $3,4($2)
        lw      $2,0($2)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L12:
        lw      $2,48($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L13
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L11:
        lw      $2,48($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L14
        nop

        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_transpose:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        lw      $2,48($fp)
        nop
        lw      $3,8($2)
        lw      $2,48($fp)
        nop
        lw      $2,4($2)
        nop
        move    $5,$2
        move    $4,$3
        jal     matrix_create
        nop

        sw      $2,32($fp)
        sw      $0,24($fp)
        b       $L17
        nop

$L20:
        sw      $0,28($fp)
        b       $L18
        nop

$L19:
        lw      $2,48($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,32($fp)
        nop
        lw      $4,0($3)
        lw      $3,28($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $4,0($3)
        lw      $3,24($fp)
        nop
        sll     $3,$3,3
        addu    $4,$4,$3
        lw      $3,4($2)
        lw      $2,0($2)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L18:
        lw      $2,48($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L19
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L17:
        lw      $2,48($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L20
        nop

        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_multiply:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        sw      $18,52($sp)
        sw      $17,48($sp)
        sw      $16,44($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        lw      $2,64($fp)
        nop
        lw      $3,4($2)
        lw      $2,68($fp)
        nop
        lw      $2,8($2)
        nop
        move    $5,$2
        move    $4,$3
        jal     matrix_create
        nop

        sw      $2,36($fp)
        sw      $0,24($fp)
        b       $L23
        nop

$L28:
        sw      $0,28($fp)
        b       $L24
        nop

$L27:
        sw      $0,32($fp)
        b       $L25
        nop

$L26:
        lw      $2,36($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $17,4($2)
        lw      $16,0($2)
        lw      $2,64($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,68($fp)
        nop
        lw      $5,0($4)
        lw      $4,32($fp)
        nop
        sll     $4,$4,2
        addu    $4,$5,$4
        lw      $5,0($4)
        lw      $4,28($fp)
        nop
        sll     $4,$4,3
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop

        move    $5,$3
        move    $4,$2
        lw      $2,36($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $18,$3,$2
        move    $7,$5
        move    $6,$4
        move    $5,$17
        move    $4,$16
        jal     __adddf3
        nop

        sw      $3,4($18)
        sw      $2,0($18)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L25:
        lw      $2,64($fp)
        nop
        lw      $2,8($2)
        lw      $3,32($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L26
        nop

        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L24:
        lw      $2,68($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L27
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L23:
        lw      $2,64($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L28
        nop

        lw      $2,36($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        lw      $18,52($sp)
        lw      $17,48($sp)
        lw      $16,44($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

matrix_subtract:
        addiu   $sp,$sp,-56
        sw      $31,52($sp)
        sw      $fp,48($sp)
        sw      $16,44($sp)
        move    $fp,$sp
        sw      $4,56($fp)
        sw      $5,60($fp)
        lw      $2,56($fp)
        nop
        lw      $3,4($2)
        lw      $2,56($fp)
        nop
        lw      $2,8($2)
        nop
        move    $5,$2
        move    $4,$3
        jal     matrix_create
        nop

        sw      $2,32($fp)
        sw      $0,24($fp)
        b       $L31
        nop

$L34:
        sw      $0,28($fp)
        b       $L32
        nop

$L33:
        lw      $2,56($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,60($fp)
        nop
        lw      $5,0($4)
        lw      $4,24($fp)
        nop
        sll     $4,$4,2
        addu    $4,$5,$4
        lw      $5,0($4)
        lw      $4,28($fp)
        nop
        sll     $4,$4,3
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        lw      $6,32($fp)
        nop
        lw      $7,0($6)
        lw      $6,24($fp)
        nop
        sll     $6,$6,2
        addu    $6,$7,$6
        lw      $7,0($6)
        lw      $6,28($fp)
        nop
        sll     $6,$6,3
        addu    $16,$7,$6
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L32:
        lw      $2,56($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L33
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L31:
        lw      $2,56($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L34
        nop

        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,52($sp)
        lw      $fp,48($sp)
        lw      $16,44($sp)
        addiu   $sp,$sp,56
        jr      $31
        nop

$LC0:
        .ascii  "%.6f \000"
matrix_print:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $0,24($fp)
        b       $L37
        nop

$L40:
        sw      $0,28($fp)
        b       $L38
        nop

$L39:
        lw      $2,40($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        move    $7,$3
        move    $6,$2
        lui     $2,%hi($LC0)
        addiu   $4,$2,%lo($LC0)
        jal     printf
        nop

        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L38:
        lw      $2,40($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L39
        nop

        li      $4,10                 # 0xa
        jal     putchar
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L37:
        lw      $2,40($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L40
        nop

        nop
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr      $31
        nop

vector_dot:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        sw      $5,52($fp)
        sw      $6,56($fp)
        sw      $0,28($fp)
        sw      $0,24($fp)
        sw      $0,32($fp)
        b       $L42
        nop

$L43:
        lw      $2,32($fp)
        nop
        sll     $2,$2,3
        lw      $3,48($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,32($fp)
        nop
        sll     $4,$4,3
        lw      $5,52($fp)
        nop
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
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __adddf3
        nop

        sw      $3,28($fp)
        sw      $2,24($fp)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L42:
        lw      $3,32($fp)
        lw      $2,56($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L43
        nop

        lw      $3,28($fp)
        lw      $2,24($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

matrix_vector_multiply:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        sw      $18,52($sp)
        sw      $17,48($sp)
        sw      $16,44($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        sw      $6,72($fp)
        lw      $2,64($fp)
        nop
        lw      $2,4($2)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,32($fp)
        lw      $2,64($fp)
        nop
        lw      $2,4($2)
        nop
        sll     $2,$2,3
        move    $6,$2
        move    $5,$0
        lw      $4,32($fp)
        jal     memset
        nop

        lw      $2,64($fp)
        nop
        lw      $3,4($2)
        lw      $2,72($fp)
        nop
        sw      $3,0($2)
        sw      $0,24($fp)
        b       $L46
        nop

$L49:
        sw      $0,28($fp)
        b       $L47
        nop

$L48:
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,32($fp)
        nop
        addu    $2,$3,$2
        lw      $17,4($2)
        lw      $16,0($2)
        lw      $2,64($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,28($fp)
        nop
        sll     $4,$4,3
        lw      $5,68($fp)
        nop
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop

        move    $5,$3
        move    $4,$2
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,32($fp)
        nop
        addu    $18,$3,$2
        move    $7,$5
        move    $6,$4
        move    $5,$17
        move    $4,$16
        jal     __adddf3
        nop

        sw      $3,4($18)
        sw      $2,0($18)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L47:
        lw      $2,64($fp)
        nop
        lw      $2,8($2)
        lw      $3,28($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L48
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L46:
        lw      $2,64($fp)
        nop
        lw      $2,4($2)
        lw      $3,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L49
        nop

        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        lw      $18,52($sp)
        lw      $17,48($sp)
        lw      $16,44($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

vector_subtract:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        sw      $16,36($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        sw      $5,52($fp)
        sw      $6,56($fp)
        lw      $2,56($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,28($fp)
        sw      $0,24($fp)
        b       $L52
        nop

$L53:
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,48($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,24($fp)
        nop
        sll     $4,$4,3
        lw      $5,52($fp)
        nop
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        lw      $6,24($fp)
        nop
        sll     $6,$6,3
        lw      $7,28($fp)
        nop
        addu    $16,$7,$6
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L52:
        lw      $3,24($fp)
        lw      $2,56($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L53
        nop

        lw      $2,28($fp)
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        lw      $16,36($sp)
        addiu   $sp,$sp,48
        jr      $31
        nop

swap_double:
        addiu   $sp,$sp,-24
        sw      $fp,20($sp)
        move    $fp,$sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        lw      $2,24($fp)
        nop
        lw      $3,4($2)
        lw      $2,0($2)
        sw      $3,12($fp)
        sw      $2,8($fp)
        lw      $2,28($fp)
        nop
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,24($fp)
        nop
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $4,28($fp)
        lw      $3,12($fp)
        lw      $2,8($fp)
        sw      $3,4($4)
        sw      $2,0($4)
        nop
        move    $sp,$fp
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr      $31
        nop

swap_matrix_rows:
        addiu   $sp,$sp,-24
        sw      $fp,20($sp)
        move    $fp,$sp
        sw      $4,24($fp)
        sw      $5,28($fp)
        sw      $6,32($fp)
        lw      $2,24($fp)
        nop
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $2,0($2)
        nop
        sw      $2,8($fp)
        lw      $2,24($fp)
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addu    $3,$3,$2
        lw      $2,24($fp)
        nop
        lw      $4,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        lw      $3,0($3)
        nop
        sw      $3,0($2)
        lw      $2,24($fp)
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,8($fp)
        nop
        sw      $3,0($2)
        nop
        move    $sp,$fp
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr      $31
        nop

$LC2:
        .ascii  "Error: Singular matrix\000"
solve_linear_system:
        addiu   $sp,$sp,-128
        sw      $31,124($sp)
        sw      $fp,120($sp)
        sw      $23,116($sp)
        sw      $22,112($sp)
        sw      $21,108($sp)
        sw      $20,104($sp)
        sw      $19,100($sp)
        sw      $18,96($sp)
        sw      $17,92($sp)
        sw      $16,88($sp)
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
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,64($fp)
        lw      $2,136($fp)
        nop
        sll     $2,$2,3
        move    $6,$2
        lw      $5,132($fp)
        lw      $4,64($fp)
        jal     memcpy
        nop

        sw      $0,24($fp)
        b       $L58
        nop

$L70:
        lw      $2,24($fp)
        nop
        sw      $2,28($fp)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
        b       $L59
        nop

$L62:
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        li      $4,2147418112                 # 0x7fff0000
        ori     $4,$4,0xffff
        and     $16,$2,$4
        move    $17,$3
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        li      $4,2147418112                 # 0x7fff0000
        ori     $4,$4,0xffff
        and     $18,$2,$4
        move    $19,$3
        move    $7,$19
        move    $6,$18
        move    $5,$17
        move    $4,$16
        jal     __gtdf2
        nop

        blez    $2,$L60
        nop

        lw      $2,32($fp)
        nop
        sw      $2,28($fp)
$L60:
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L59:
        lw      $3,32($fp)
        lw      $2,136($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L62
        nop

        lw      $6,28($fp)
        lw      $5,24($fp)
        lw      $4,60($fp)
        jal     swap_matrix_rows
        nop

        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $4,$3,$2
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $2,$3,$2
        move    $5,$2
        jal     swap_double
        nop

        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        li      $4,2147418112                 # 0x7fff0000
        ori     $4,$4,0xffff
        and     $20,$2,$4
        move    $21,$3
        lui     $2,%hi($LC1)
        lw      $7,%lo($LC1+4)($2)
        lw      $6,%lo($LC1)($2)
        move    $5,$21
        move    $4,$20
        jal     __ltdf2
        nop

        bgez    $2,$L77
        nop

        lui     $2,%hi($LC2)
        addiu   $4,$2,%lo($LC2)
        jal     puts
        nop

        lw      $4,60($fp)
        jal     matrix_free
        nop

        lw      $4,64($fp)
        jal     free
        nop

        lw      $2,140($fp)
        nop
        sw      $0,0($2)
        move    $2,$0
        b       $L65
        nop

$L77:
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,36($fp)
        b       $L66
        nop

$L69:
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,36($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,60($fp)
        nop
        lw      $5,0($4)
        lw      $4,24($fp)
        nop
        sll     $4,$4,2
        addu    $4,$5,$4
        lw      $5,0($4)
        lw      $4,24($fp)
        nop
        sll     $4,$4,3
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __divdf3
        nop

        sw      $3,76($fp)
        sw      $2,72($fp)
        lw      $2,36($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $2,$3,$2
        lw      $23,4($2)
        lw      $22,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
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
        lw      $2,36($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $2,$3,$2
        sw      $2,80($fp)
        move    $7,$5
        move    $6,$4
        move    $5,$23
        move    $4,$22
        jal     __subdf3
        nop

        lw      $4,80($fp)
        nop
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,24($fp)
        nop
        sw      $2,40($fp)
        b       $L67
        nop

$L68:
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,36($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $23,4($2)
        lw      $22,0($2)
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,24($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        nop
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
        nop
        lw      $3,0($2)
        lw      $2,36($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,40($fp)
        nop
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
        nop
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,40($fp)
        nop
        addiu   $2,$2,1
        sw      $2,40($fp)
$L67:
        lw      $3,40($fp)
        lw      $2,136($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L68
        nop

        lw      $2,36($fp)
        nop
        addiu   $2,$2,1
        sw      $2,36($fp)
$L66:
        lw      $3,36($fp)
        lw      $2,136($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L69
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L58:
        lw      $3,24($fp)
        lw      $2,136($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L70
        nop

        lw      $2,136($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,68($fp)
        lw      $2,136($fp)
        nop
        addiu   $2,$2,-1
        sw      $2,44($fp)
        b       $L71
        nop

$L74:
        sw      $0,52($fp)
        sw      $0,48($fp)
        lw      $2,44($fp)
        nop
        addiu   $2,$2,1
        sw      $2,56($fp)
        b       $L72
        nop

$L73:
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,44($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,56($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,56($fp)
        nop
        sll     $4,$4,3
        lw      $5,68($fp)
        nop
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
        nop
        addiu   $2,$2,1
        sw      $2,56($fp)
$L72:
        lw      $3,56($fp)
        lw      $2,136($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L73
        nop

        lw      $2,44($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,52($fp)
        lw      $6,48($fp)
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        move    $9,$3
        move    $8,$2
        lw      $2,60($fp)
        nop
        lw      $3,0($2)
        lw      $2,44($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,44($fp)
        nop
        sll     $2,$2,3
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,44($fp)
        nop
        sll     $4,$4,3
        lw      $5,68($fp)
        nop
        addu    $16,$5,$4
        move    $7,$3
        move    $6,$2
        move    $5,$9
        move    $4,$8
        jal     __divdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,44($fp)
        nop
        addiu   $2,$2,-1
        sw      $2,44($fp)
$L71:
        lw      $2,44($fp)
        nop
        bgez    $2,$L74
        nop

        lw      $4,60($fp)
        jal     matrix_free
        nop

        lw      $4,64($fp)
        jal     free
        nop

        lw      $2,140($fp)
        lw      $3,136($fp)
        nop
        sw      $3,0($2)
        lw      $2,68($fp)
$L65:
        move    $sp,$fp
        lw      $31,124($sp)
        lw      $fp,120($sp)
        lw      $23,116($sp)
        lw      $22,112($sp)
        lw      $21,108($sp)
        lw      $20,104($sp)
        lw      $19,100($sp)
        lw      $18,96($sp)
        lw      $17,92($sp)
        lw      $16,88($sp)
        addiu   $sp,$sp,128
        jr      $31
        nop

$LC3:
        .ascii  "r\000"
$LC4:
        .ascii  "Error: Cannot open file %s\012\000"
$LC5:
        .ascii  "%lf\000"
read_signal:
        addiu   $sp,$sp,-56
        sw      $31,52($sp)
        sw      $fp,48($sp)
        move    $fp,$sp
        sw      $4,56($fp)
        sw      $5,60($fp)
        lui     $2,%hi($LC3)
        addiu   $5,$2,%lo($LC3)
        lw      $4,56($fp)
        jal     fopen
        nop

        sw      $2,32($fp)
        lw      $2,32($fp)
        nop
        bne     $2,$0,$L79
        nop

        lw      $5,56($fp)
        lui     $2,%hi($LC4)
        addiu   $4,$2,%lo($LC4)
        jal     printf
        nop

        lw      $2,60($fp)
        nop
        sw      $0,0($2)
        move    $2,$0
        b       $L85
        nop

$L79:
        sw      $0,24($fp)
        b       $L81
        nop

$L82:
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L81:
        addiu   $2,$fp,40
        move    $6,$2
        lui     $2,%hi($LC5)
        addiu   $5,$2,%lo($LC5)
        lw      $4,32($fp)
        jal     __isoc23_fscanf
        nop

        move    $3,$2
        li      $2,1                        # 0x1
        beq     $3,$2,$L82
        nop

        move    $6,$0
        move    $5,$0
        lw      $4,32($fp)
        jal     fseek
        nop

        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,36($fp)
        lw      $2,60($fp)
        lw      $3,24($fp)
        nop
        sw      $3,0($2)
        sw      $0,28($fp)
        b       $L83
        nop

$L84:
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        lw      $3,36($fp)
        nop
        addu    $2,$3,$2
        move    $6,$2
        lui     $2,%hi($LC5)
        addiu   $5,$2,%lo($LC5)
        lw      $4,32($fp)
        jal     __isoc23_fscanf
        nop

        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L83:
        lw      $3,28($fp)
        lw      $2,24($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L84
        nop

        lw      $4,32($fp)
        jal     fclose
        nop

        lw      $2,36($fp)
$L85:
        move    $sp,$fp
        lw      $31,52($sp)
        lw      $fp,48($sp)
        addiu   $sp,$sp,56
        jr      $31
        nop

compute_autocorrelation:
        addiu   $sp,$sp,-80
        sw      $31,76($sp)
        sw      $fp,72($sp)
        sw      $16,68($sp)
        move    $fp,$sp
        sw      $4,80($fp)
        sw      $5,84($fp)
        sw      $6,88($fp)
        lw      $5,88($fp)
        lw      $4,88($fp)
        jal     matrix_create
        nop

        sw      $2,52($fp)
        lw      $2,88($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,56($fp)
        lw      $2,88($fp)
        nop
        sll     $2,$2,3
        move    $6,$2
        move    $5,$0
        lw      $4,56($fp)
        jal     memset
        nop

        sw      $0,24($fp)
        b       $L87
        nop

$L90:
        sw      $0,36($fp)
        sw      $0,32($fp)
        lw      $2,24($fp)
        nop
        sw      $2,40($fp)
        b       $L88
        nop

$L89:
        lw      $2,40($fp)
        nop
        sll     $2,$2,3
        lw      $3,80($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $5,40($fp)
        lw      $4,24($fp)
        nop
        subu    $4,$5,$4
        sll     $4,$4,3
        lw      $5,80($fp)
        nop
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
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __adddf3
        nop

        sw      $3,36($fp)
        sw      $2,32($fp)
        lw      $2,40($fp)
        nop
        addiu   $2,$2,1
        sw      $2,40($fp)
$L88:
        lw      $3,40($fp)
        lw      $2,84($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L89
        nop

        lw      $4,84($fp)
        jal     __floatsidf
        nop

        lw      $4,24($fp)
        nop
        sll     $4,$4,3
        lw      $5,56($fp)
        nop
        addu    $16,$5,$4
        move    $7,$3
        move    $6,$2
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __divdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L87:
        lw      $3,24($fp)
        lw      $2,88($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L90
        nop

        sw      $0,44($fp)
        b       $L91
        nop

$L95:
        sw      $0,48($fp)
        b       $L92
        nop

$L94:
        lw      $3,44($fp)
        lw      $2,48($fp)
        nop
        subu    $2,$3,$2
        bgez    $2,$L93
        nop

        subu    $2,$0,$2
$L93:
        sw      $2,60($fp)
        lw      $2,60($fp)
        nop
        sll     $2,$2,3
        lw      $3,56($fp)
        nop
        addu    $2,$3,$2
        lw      $3,52($fp)
        nop
        lw      $4,0($3)
        lw      $3,44($fp)
        nop
        sll     $3,$3,2
        addu    $3,$4,$3
        lw      $4,0($3)
        lw      $3,48($fp)
        nop
        sll     $3,$3,3
        addu    $4,$4,$3
        lw      $3,4($2)
        lw      $2,0($2)
        sw      $3,4($4)
        sw      $2,0($4)
        lw      $2,48($fp)
        nop
        addiu   $2,$2,1
        sw      $2,48($fp)
$L92:
        lw      $3,48($fp)
        lw      $2,88($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L94
        nop

        lw      $2,44($fp)
        nop
        addiu   $2,$2,1
        sw      $2,44($fp)
$L91:
        lw      $3,44($fp)
        lw      $2,88($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L95
        nop

        lw      $4,56($fp)
        jal     free
        nop

        lw      $2,52($fp)
        move    $sp,$fp
        lw      $31,76($sp)
        lw      $fp,72($sp)
        lw      $16,68($sp)
        addiu   $sp,$sp,80
        jr      $31
        nop

compute_cross_correlation:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        sw      $16,52($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        sw      $6,72($fp)
        sw      $7,76($fp)
        lw      $2,76($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,44($fp)
        lw      $2,76($fp)
        nop
        sll     $2,$2,3
        move    $6,$2
        move    $5,$0
        lw      $4,44($fp)
        jal     memset
        nop

        lw      $2,80($fp)
        lw      $3,76($fp)
        nop
        sw      $3,0($2)
        sw      $0,24($fp)
        b       $L98
        nop

$L101:
        sw      $0,36($fp)
        sw      $0,32($fp)
        lw      $2,24($fp)
        nop
        sw      $2,40($fp)
        b       $L99
        nop

$L100:
        lw      $2,40($fp)
        nop
        sll     $2,$2,3
        lw      $3,64($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $5,40($fp)
        lw      $4,24($fp)
        nop
        subu    $4,$5,$4
        sll     $4,$4,3
        lw      $5,68($fp)
        nop
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
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __adddf3
        nop

        sw      $3,36($fp)
        sw      $2,32($fp)
        lw      $2,40($fp)
        nop
        addiu   $2,$2,1
        sw      $2,40($fp)
$L99:
        lw      $3,40($fp)
        lw      $2,72($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L100
        nop

        lw      $4,72($fp)
        jal     __floatsidf
        nop

        lw      $4,24($fp)
        nop
        sll     $4,$4,3
        lw      $5,44($fp)
        nop
        addu    $16,$5,$4
        move    $7,$3
        move    $6,$2
        lw      $5,36($fp)
        lw      $4,32($fp)
        jal     __divdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L98:
        lw      $3,24($fp)
        lw      $2,76($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L101
        nop

        lw      $2,44($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        lw      $16,52($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

apply_filter:
        addiu   $sp,$sp,-64
        sw      $31,60($sp)
        sw      $fp,56($sp)
        sw      $18,52($sp)
        sw      $17,48($sp)
        sw      $16,44($sp)
        move    $fp,$sp
        sw      $4,64($fp)
        sw      $5,68($fp)
        sw      $6,72($fp)
        sw      $7,76($fp)
        lw      $2,72($fp)
        nop
        sll     $2,$2,3
        move    $4,$2
        jal     malloc
        nop

        sw      $2,32($fp)
        lw      $2,72($fp)
        nop
        sll     $2,$2,3
        move    $6,$2
        move    $5,$0
        lw      $4,32($fp)
        jal     memset
        nop

        lw      $2,80($fp)
        lw      $3,72($fp)
        nop
        sw      $3,0($2)
        sw      $0,24($fp)
        b       $L104
        nop

$L108:
        sw      $0,28($fp)
        b       $L105
        nop

$L107:
        lw      $3,24($fp)
        lw      $2,28($fp)
        nop
        subu    $2,$3,$2
        sw      $2,36($fp)
        lw      $2,36($fp)
        nop
        bltz    $2,$L106
        nop

        lw      $3,36($fp)
        lw      $2,72($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L106
        nop

        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,32($fp)
        nop
        addu    $2,$3,$2
        lw      $17,4($2)
        lw      $16,0($2)
        lw      $2,28($fp)
        nop
        sll     $2,$2,3
        lw      $3,68($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,36($fp)
        nop
        sll     $4,$4,3
        lw      $5,64($fp)
        nop
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop

        move    $5,$3
        move    $4,$2
        lw      $2,24($fp)
        nop
        sll     $2,$2,3
        lw      $3,32($fp)
        nop
        addu    $18,$3,$2
        move    $7,$5
        move    $6,$4
        move    $5,$17
        move    $4,$16
        jal     __adddf3
        nop

        sw      $3,4($18)
        sw      $2,0($18)
$L106:
        lw      $2,28($fp)
        nop
        addiu   $2,$2,1
        sw      $2,28($fp)
$L105:
        lw      $3,28($fp)
        lw      $2,76($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L107
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
$L104:
        lw      $3,24($fp)
        lw      $2,72($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L108
        nop

        lw      $2,32($fp)
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        lw      $18,52($sp)
        lw      $17,48($sp)
        lw      $16,44($sp)
        addiu   $sp,$sp,64
        jr      $31
        nop

calculate_variance:
        addiu   $sp,$sp,-72
        sw      $31,68($sp)
        sw      $fp,64($sp)
        sw      $17,60($sp)
        sw      $16,56($sp)
        move    $fp,$sp
        sw      $4,72($fp)
        sw      $5,76($fp)
        sw      $0,28($fp)
        sw      $0,24($fp)
        sw      $0,32($fp)
        b       $L111
        nop

$L112:
        lw      $2,32($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        move    $7,$3
        move    $6,$2
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __adddf3
        nop

        sw      $3,28($fp)
        sw      $2,24($fp)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L111:
        lw      $3,32($fp)
        lw      $2,76($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L112
        nop

        lw      $4,76($fp)
        jal     __floatsidf
        nop

        move    $7,$3
        move    $6,$2
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __divdf3
        nop

        sw      $3,28($fp)
        sw      $2,24($fp)
        sw      $0,44($fp)
        sw      $0,40($fp)
        sw      $0,48($fp)
        b       $L113
        nop

$L114:
        lw      $2,48($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,28($fp)
        lw      $6,24($fp)
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        move    $17,$3
        move    $16,$2
        lw      $2,48($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $7,28($fp)
        lw      $6,24($fp)
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        move    $7,$3
        move    $6,$2
        move    $5,$17
        move    $4,$16
        jal     __muldf3
        nop

        move    $7,$3
        move    $6,$2
        lw      $5,44($fp)
        lw      $4,40($fp)
        jal     __adddf3
        nop

        sw      $3,44($fp)
        sw      $2,40($fp)
        lw      $2,48($fp)
        nop
        addiu   $2,$2,1
        sw      $2,48($fp)
$L113:
        lw      $3,48($fp)
        lw      $2,76($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L114
        nop

        lw      $4,76($fp)
        jal     __floatsidf
        nop

        move    $7,$3
        move    $6,$2
        lw      $5,44($fp)
        lw      $4,40($fp)
        jal     __divdf3
        nop

        move    $sp,$fp
        lw      $31,68($sp)
        lw      $fp,64($sp)
        lw      $17,60($sp)
        lw      $16,56($sp)
        addiu   $sp,$sp,72
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
        sw      $0,28($fp)
        sw      $0,24($fp)
        sw      $0,32($fp)
        b       $L117
        nop

$L118:
        lw      $2,32($fp)
        nop
        sll     $2,$2,3
        lw      $3,56($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lw      $4,32($fp)
        nop
        sll     $4,$4,3
        lw      $5,60($fp)
        nop
        addu    $4,$5,$4
        lw      $5,4($4)
        lw      $4,0($4)
        move    $7,$5
        move    $6,$4
        move    $5,$3
        move    $4,$2
        jal     __subdf3
        nop

        sw      $3,44($fp)
        sw      $2,40($fp)
        lw      $7,44($fp)
        lw      $6,40($fp)
        lw      $5,44($fp)
        lw      $4,40($fp)
        jal     __muldf3
        nop

        move    $7,$3
        move    $6,$2
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __adddf3
        nop

        sw      $3,28($fp)
        sw      $2,24($fp)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L117:
        lw      $3,32($fp)
        lw      $2,64($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L118
        nop

        lw      $4,64($fp)
        jal     __floatsidf
        nop

        move    $7,$3
        move    $6,$2
        lw      $5,28($fp)
        lw      $4,24($fp)
        jal     __divdf3
        nop

        move    $sp,$fp
        lw      $31,52($sp)
        lw      $fp,48($sp)
        addiu   $sp,$sp,56
        jr      $31
        nop

$LC6:
        .ascii  "desired.txt\000"
$LC7:
        .ascii  "input.txt\000"
$LC8:
        .ascii  "Error: size not match\000"
$LC9:
        .ascii  "w\000"
$LC10:
        .ascii  "output.txt\000"
$LC11:
        .ascii  "Error: size not match\012\000"
$LC12:
        .ascii  "Error: Cannot solve linear system\000"
$LC14:
        .ascii  "Filtered output:\000"
$LC15:
        .ascii  " %9.4f\000"
$LC16:
        .ascii  "MMSE: %.4f\012\000"
main:
        addiu   $sp,$sp,-136
        sw      $31,132($sp)
        sw      $fp,128($sp)
        sw      $16,124($sp)
        move    $fp,$sp
        addiu   $2,$fp,96
        move    $5,$2
        lui     $2,%hi($LC6)
        addiu   $4,$2,%lo($LC6)
        jal     read_signal
        nop

        sw      $2,44($fp)
        addiu   $2,$fp,100
        move    $5,$2
        lui     $2,%hi($LC7)
        addiu   $4,$2,%lo($LC7)
        jal     read_signal
        nop

        sw      $2,48($fp)
        lw      $2,44($fp)
        nop
        beq     $2,$0,$L121
        nop

        lw      $2,48($fp)
        nop
        beq     $2,$0,$L121
        nop

        lw      $3,96($fp)
        li      $2,10                 # 0xa
        bne     $3,$2,$L121
        nop

        lw      $3,100($fp)
        li      $2,10                 # 0xa
        beq     $3,$2,$L122
        nop

$L121:
        lui     $2,%hi($LC8)
        addiu   $4,$2,%lo($LC8)
        jal     puts
        nop

        lui     $2,%hi($LC9)
        addiu   $5,$2,%lo($LC9)
        lui     $2,%hi($LC10)
        addiu   $4,$2,%lo($LC10)
        jal     fopen
        nop

        sw      $2,92($fp)
        lw      $2,92($fp)
        nop
        beq     $2,$0,$L123
        nop

        lw      $7,92($fp)
        li      $6,22                 # 0x16
        li      $5,1                        # 0x1
        lui     $2,%hi($LC11)
        addiu   $4,$2,%lo($LC11)
        jal     fwrite
        nop

        lw      $4,92($fp)
        jal     fclose
        nop

$L123:
        lw      $4,44($fp)
        jal     free
        nop

        lw      $4,48($fp)
        jal     free
        nop

        li      $2,1                        # 0x1
        b       $L133
        nop

$L122:
        li      $2,10                 # 0xa
        sw      $2,52($fp)
        lw      $2,100($fp)
        nop
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
        lw      $6,52($fp)
        lw      $5,64($fp)
        lw      $4,60($fp)
        jal     solve_linear_system
        nop

        sw      $2,68($fp)
        lw      $2,68($fp)
        nop
        bne     $2,$0,$L125
        nop

        lui     $2,%hi($LC12)
        addiu   $4,$2,%lo($LC12)
        jal     puts
        nop

        lw      $4,60($fp)
        jal     matrix_free
        nop

        lw      $4,44($fp)
        jal     free
        nop

        lw      $4,48($fp)
        jal     free
        nop

        lw      $4,64($fp)
        jal     free
        nop

        li      $2,1                        # 0x1
        b       $L133
        nop

$L125:
        addiu   $2,$fp,112
        sw      $2,16($sp)
        lw      $7,52($fp)
        lw      $6,56($fp)
        lw      $5,68($fp)
        lw      $4,48($fp)
        jal     apply_filter
        nop

        sw      $2,72($fp)
        lw      $2,100($fp)
        nop
        move    $6,$2
        lw      $5,72($fp)
        lw      $4,44($fp)
        jal     calculate_mmse
        nop

        sw      $3,84($fp)
        sw      $2,80($fp)
        sw      $0,32($fp)
        b       $L126
        nop

$L127:
        lw      $2,32($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        lui     $4,%hi($LC13)
        lw      $7,%lo($LC13+4)($4)
        lw      $6,%lo($LC13)($4)
        move    $5,$3
        move    $4,$2
        jal     __muldf3
        nop

        move    $5,$3
        move    $4,$2
        jal     round
        nop

        lw      $4,32($fp)
        nop
        sll     $4,$4,3
        lw      $5,72($fp)
        nop
        addu    $16,$5,$4
        lui     $4,%hi($LC13)
        lw      $7,%lo($LC13+4)($4)
        lw      $6,%lo($LC13)($4)
        move    $5,$3
        move    $4,$2
        jal     __divdf3
        nop

        sw      $3,4($16)
        sw      $2,0($16)
        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
$L126:
        lw      $2,112($fp)
        lw      $3,32($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L127
        nop

        lw      $2,100($fp)
        nop
        move    $6,$2
        lw      $5,72($fp)
        lw      $4,44($fp)
        jal     calculate_mmse
        nop

        sw      $3,84($fp)
        sw      $2,80($fp)
        lui     $2,%hi($LC13)
        lw      $7,%lo($LC13+4)($2)
        lw      $6,%lo($LC13)($2)
        lw      $5,84($fp)
        lw      $4,80($fp)
        jal     __muldf3
        nop

        move    $5,$3
        move    $4,$2
        jal     round
        nop

        lui     $4,%hi($LC13)
        lw      $7,%lo($LC13+4)($4)
        lw      $6,%lo($LC13)($4)
        move    $5,$3
        move    $4,$2
        jal     __divdf3
        nop

        sw      $3,84($fp)
        sw      $2,80($fp)
        lui     $2,%hi($LC14)
        addiu   $4,$2,%lo($LC14)
        jal     printf
        nop

        sw      $0,36($fp)
        b       $L128
        nop

$L129:
        lw      $2,36($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        move    $7,$3
        move    $6,$2
        lui     $2,%hi($LC15)
        addiu   $4,$2,%lo($LC15)
        jal     printf
        nop

        lw      $2,36($fp)
        nop
        addiu   $2,$2,1
        sw      $2,36($fp)
$L128:
        lw      $2,112($fp)
        lw      $3,36($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L129
        nop

        li      $4,10                 # 0xa
        jal     putchar
        nop

        lw      $7,84($fp)
        lw      $6,80($fp)
        lui     $2,%hi($LC16)
        addiu   $4,$2,%lo($LC16)
        jal     printf
        nop

        lui     $2,%hi($LC9)
        addiu   $5,$2,%lo($LC9)
        lui     $2,%hi($LC10)
        addiu   $4,$2,%lo($LC10)
        jal     fopen
        nop

        sw      $2,88($fp)
        lw      $2,88($fp)
        nop
        beq     $2,$0,$L130
        nop

        lw      $7,88($fp)
        li      $6,16                 # 0x10
        li      $5,1                        # 0x1
        lui     $2,%hi($LC14)
        addiu   $4,$2,%lo($LC14)
        jal     fwrite
        nop

        sw      $0,40($fp)
        b       $L131
        nop

$L132:
        lw      $2,40($fp)
        nop
        sll     $2,$2,3
        lw      $3,72($fp)
        nop
        addu    $2,$3,$2
        lw      $3,4($2)
        lw      $2,0($2)
        move    $7,$3
        move    $6,$2
        lui     $2,%hi($LC15)
        addiu   $5,$2,%lo($LC15)
        lw      $4,88($fp)
        jal     fprintf
        nop

        lw      $2,40($fp)
        nop
        addiu   $2,$2,1
        sw      $2,40($fp)
$L131:
        lw      $2,112($fp)
        lw      $3,40($fp)
        nop
        slt     $2,$3,$2
        bne     $2,$0,$L132
        nop

        lw      $5,88($fp)
        li      $4,10                 # 0xa
        jal     fputc
        nop

        lw      $7,84($fp)
        lw      $6,80($fp)
        lui     $2,%hi($LC16)
        addiu   $5,$2,%lo($LC16)
        lw      $4,88($fp)
        jal     fprintf
        nop

        lw      $4,88($fp)
        jal     fclose
        nop

$L130:
        lw      $4,60($fp)
        jal     matrix_free
        nop

        lw      $4,44($fp)
        jal     free
        nop

        lw      $4,48($fp)
        jal     free
        nop

        lw      $4,64($fp)
        jal     free
        nop

        lw      $4,68($fp)
        jal     free
        nop

        lw      $4,72($fp)
        jal     free
        nop

        move    $2,$0
$L133:
        move    $sp,$fp
        lw      $31,132($sp)
        lw      $fp,128($sp)
        lw      $16,124($sp)
        addiu   $sp,$sp,136
        jr      $31
        nop

$LC1:
        .word   1037794527
        .word   -640172613
$LC13:
        .word   1076101120
        .word   0