// File: assign1a.s
// Author: Vidhi Soni 
// Date: January 26th, 2021
//
//Description:
//  An assembly language program that finds the min of y = 3x^4 -287x^2 - 63x + 37 in range -10 <= x <= 10. Then it prints the values x and y, and the current minimum of each iteration of your loop.
// This is version 1(a),so the program is written without macros and uses a pre-test loop, where the test is at the top of the loop.

fmt:   .string " x = %d, y = %d. \n Minimum value of y = %d. \n"    //formats all  output as string
       .balign 4                                                   // ensures next instruction's adress is divisible by 4(4-byte alligned to the word length of the machine)


      .global main                                                //enables the "main" label to be visible to the linker

main:
      stp x29,x30, [sp,-16]!                                     //saves frame pointer (FP) and link register (LR) to the stack
      mov x29,sp                                                 // update FP to the top of the stack

      mov x19, 0                                                 //x19 = 0 (register for the loop count)
      mov x20, 0                                                 //x20 = 0 (register for y)
      mov x21, 0                                                 //x21  =  0 (register for the min of y)
      mov x22, -10                                               // x22 = -10 (register for x, which has an inital value of the smallest number in the range -10<= x <=10)

loop_test:

      cmp x22, 10                                                //pre test loop that compares x to the highest value in range (-10,19)
      b.gt done                                                  // branches to the label done(end of code) if x>10
      mov x20, 0                                                 // when loop is run x20 = 0, where x20 is the register for the y value

      mov x23, 3                                                 //x23 = 3 ( register for 3 and 3 comes from the equation where 3x^4)
      mul x23, x23, x22                                          //x23 = 3x ( mul multiplies 3 and x)
      mul x23, x23, x22                                          //x23 = 3x^2 ( mul multiplies 3x and x)
      mul x23, x23, x22                                          //x23 = 3x^3 ( mul multiplies 3x^2 and x)
      mul x23, x23, x22                                          //x23 = 3x^4 ( mul multiplies 3x^3 and x)

      mov x24, -287                                             //x24 =-287 ( register for 287 and 287 comes from the equation where - 287x^2)
      mul x24, x24, x22                                         // x24 = -287x ( mul multiplies -287 and x)
      mul x24, x24, x22                                         //x24 = -287x^2 ( mul multiplies -287x and x)

      mov x25, -63                                             //x25 = -63 ( register for -63 and -63 comes from the equation where - 63x)
      mul x25, x25, x22                                        //x25 = -63x ( mul multiplies -63 and x)

      add x20, x20, x23                                        //y + 3x^4
      add x20, x20, x24                                        //y - 287x^2
      add x20, x20, x25                                        // y - 63x
      add x20, x20, 37                                         // y +  37

      cmp x19, 0                                               //Compares loop count to 0
      b.eq set_min                                             //branches to set_min if loop count =0

      cmp x20, x21                                             //compares y to the minimum of y
      b.lt set_min	                                       //branches to  set_min if loop count < min of y


loop:
      adrp x0, fmt                                             //setting argument of printf 
      add x0, x0, :lo12:fmt                                    //add 12 bits to x0
      mov x1, x22                                              //x1 = x22 (value x)
      mov x2, x20                                              //x2 = x20 (value y)
      mov x3, x21                                              //x3 = x21 (min of y)

      bl printf                                                //call printf function
      add x22, x22, 1                                          // add 1 to loop counter everytime loop is run
      add x19, x19, 1                                          // add 1 to the x value (-10 to 10)
      b loop_test                                              // branches to loop_top to check if next value is in range (-10 to 10)

set_min:
      mov x21, x20                                             // x21 = x20 (sets y to the min of y)
      b loop                                                   // branches to loop

done:
      mov x0, 0                                                // set return code to 0 
      ldp  x29, x30, [sp], 16                                  //cleans up lines, restores the stack 

     ret                                                       // return to OS 
