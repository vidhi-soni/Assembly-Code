//Author: Vidhi Soni 
//Date: February 8th, 2022
//
//Description:
// This is an ARMv8 program that implements the integer multiplication program, using m4 macros.It also makes use of bitwise logical and shift operations, and hexadecimal and binary numbers.
//The program is written in nano. This is version 2(a),with multiplier 70 and multiplicand -16843010.

     initial:   .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x(%d) \n\n"          //formats all output as string and defines string initial
     producta:  .string "product =  0x%08x  multiplier = 0x%08x\n"                         //formats all output as string and defines string producta
     result64:  .string "64-bit-result = 0x%016lx (%ld)\n"                                 //formats all output as string and defines string result64

     define(TRUE, 1)                                                                       //define TRUE as 1
     define(FALSE, 0)                                                                      //define FALSE as 0
     define(multiplier, w19)                                                               //macro for  multiplier and multiplier = w19
     define(multiplicand, w20)                                                             //macro for multiplicand and multiplicand = w20
     define(product, w21)                                                                  //macro for  product and product = w21
     define(i, w22)                                                                        //macro for i (loop range) and i = w22
     define(neg, w23)                                                                      //macro for  neg (negative) and neg = w23 - used to check if multiplier is negative

     define(multiplier_64bit, x19)                                                         //macro for the 64 bit version of the multiplier and multiplier = x19
     define(product_64bit, x21)                                                            //macro for the 64 bit version of the product and product_64bit = x21
     define(temp1, x24)                                                                    //macro for temp1 and temp1 = x24
     define(temp2, x25)                                                                    //macro for temp2 and temp2 = x25
     define(result, x26)                                                                   //macro for result and result = x26

     .balign 4                                                                             //ensures the next instruction's address is divisible by 4
     .global main                                                                          //enables the "main" label to be visible to the linker

main:
     stp x29, x30, [sp, -16]!                                                              //save frame pointer (FP) and link register (LR) to the stack
     mov x29, sp                                                                           //update FP to the top of the stack

     mov product, 0                                                                        //product = 0
     mov i, 0                                                                              //i = 0 ( loop count is in range 0-32)
     mov multiplicand, -16843010                                                           //multiplicand = -16843010
     mov multiplier, 70                                                                    //multiplier = 70

     adrp x0, initial                                                                      //setting first argument of function printf
     add x0, x0, :lo12:initial                                                             //setting second argument of function printf
     mov w1, multiplier                                                                    //multiplier = w1
     mov w2, multiplier                                                                    //multiplier = w2
     mov w3, multiplicand                                                                  //multiplicand = w3
     mov w4, multiplicand                                                                  //multiplicand = w4
     bl printf                                                                             //call printf function

     cmp multiplier, 0                                                                     //compare multiplier to 0
     b.ge start                                                                            //if multiplier > 0 then branch to start
     mov neg, TRUE                                                                         //if multiplier < 0 then neg = TRUE (as multiplier is a negative number)

start:
     b test_one                                                                            //branch to test_one

loop:
     tst multiplier, 0x1                                                                   //compare multiplier to 1
     b.eq test_two                                                                         //if multiplier is not 1 than branch to test_two
     add product, product, multiplicand                                                    //product + multiplicand

test_two:
     asr multiplier, multiplier, 1                                                        //arithmetic shift right of multiplier by 1
     tst product, 0x1                                                                     //compare product with 1
     b.eq test_three                                                                      //if product is not 1 branch to test_three
     orr  multiplier, multiplier, 0x80000000                                              //if product is not 1 then orr operation is performed
     b test_four                                                                          //branch to test_four

test_three:
     and multiplier, multiplier, 0x7FFFFFFF                                               //else multiplier & 0x7FFFFFFF

test_four:
     asr product, product, 1                                                              //arithmetic shift right of product by 1
     add i, i, 1                                                                          //i = i+1 everytime check_four is performed

test_one:
     cmp i, 32                                                                            //compare i  to 32 (loop range is 0-32)
     b.lt loop                                                                            //if i < 32 then branch back to loop
     cmp neg, TRUE                                                                        //checks if multiplier is negative
     b.ne printing64                                                                      //If neg = FALSE, then branch to print64
     sub product, product, multiplicand                                                   //if  neg = TRUE then product - multiplicand

printing64:
     adrp x0, producta                                                                    //setting first arguement of function printf
     add x0, x0, :lo12:producta                                                           //add 12 bits to x0
     mov w1, product                                                                      //product = w1
     mov w2, multiplier                                                                   //multiplier = w2
     bl printf                                                                            //call printf function

     sxtw temp1, product                                                                  //temp1 = product
     and temp1, product_64bit, 0xFFFFFFFF                                                 //and move product_64bit, and 0xFFFFFFFF in same register temp1
     lsl temp1, temp1, 32                                                                 //logical shift left of temp1 by 32

     sxtw temp2, multiplier                                                               //multiplier = temp2
     and temp2, multiplier_64bit, 0xFFFFFFFF                                              //move multiplier_64bit and 0xFFFFFFFF into same register temp2
     add result, temp1, temp2                                                             //result = temp1 + temp2

     adrp x0, result64                                                                    //setting first arguement of function printf
     add x0, x0, :lo12:result64                                                           //add 12 bits to x0
     mov x1, result                                                                       //result = x1
     mov x2, result                                                                       //result = x2
     bl printf                                                                            //call printf function

end:
     mov     w0, 0                                                                        //set return code to 0
     ldp     x29, x30, [sp], 16                                                           //cleans up lines, restores the stack

     ret                                                                                  //return to OS
