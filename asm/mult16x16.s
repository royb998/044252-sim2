# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
    la      t3, a
    lw      t3, 0(t3)
    la      t4, b
    lw      t4, 0(t4)

    # t6 will contain the result
    add     t6, x0, x0

    # Mask for 16x8=24 multiply
    ori     t0, x0, 0xff
    slli    t0, t0, 8
    ori     t0, t0, 0xff
    slli    t0, t0, 8
    ori     t0, t0, 0xff

####################
# Start of your code

# Use the code below for 16x8 multiplication
#   mul     <PROD>, <FACTOR1>, <FACTOR2>
#   and     <PROD>, <PROD>, t0

    # Lower byte of a
    andi    t1, t3, 0xff

    # Multiply by b
    mul     t2, t1, t4
    and     t6, t2, t0

    # Upper byte of a
    srli    t1, t3, 8

    # Multiply by b
    mul     t2, t1, t4
    and     t2, t2, t0
    # Shift to correct value
    slli    t2, t2, 8

    # Combine intermediate products
    add     t6, t6, t2

after_skip:

# End of your code
####################

finish: addi    a0, x0, 1
    addi    a1, t6, 0
    ecall # print integer ecall
    addi    a0, x0, 10
    ecall # terminate ecall
