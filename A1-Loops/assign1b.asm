// Author: Vidhi Soni 
// Date: January 26th, 2021
//
//Description:
//  An assembly language program that finds the min of y = 3x^4 -287x^2 - 63x + 37 in range -10 <= x <= 10. Then it prints the values x and y, and the current minimum of each iteration of your loop.
// This is version 1(b),so the program is written with  macros and has a pre-test loop, where the test is at the bottom  of the loop.

fmt:   .string " x = %d, y = %d. \n Minimum value of y = %d. \n"    //formats all  output as string
       .balign 4                                                   // ensures next instruction's adress is divisible by 4(4-byte alligned to the word length of the machine)


      .global main                                                //enables the "main" label to be visible to the linker

main:
      stp x29,x30, [sp,-16]!                                     //saves frame pointer (FP) and link register (LR) to the stack
      mov x29,sp                                                 // update FP to the top of the stack

      define(first_r, x23)                                       // macro for first number in equation
      define(second_r, x24)                                      // macro for second number in equation
      define(third_r, x25)                                       // macro for third number in equation


      define(loop_r, x19)                                        // macro for the  loop count
      mov loop_r, 0                                              //loop_r = 0 (register for loop count)

      define(y_r, x20)                                           // macro for the y value
      mov y_r, 0                                                 //y_r = 0 ( register for the y value)

      define(miny_r, x21)                                       // macro for the minimum y value
      mov miny_r, 0                                             //miny_r = 0 (register for  min y value)

      define(x_r, x22)                                          // macro for the x value
      mov x_r, -10                                              //x_r = -10 (register for x  value - initial value of lowest in range (-10,10))


loop_test:

       mov y_r, 0                                               //  y_r = 0 for each time loop is run

       mov first_r, 3                                           // register for value 3  from equation (3x^4)
       mul first_r, first_r, x_r                                // first_r = 3x
       mul first_r, first_r, x_r                                // first_r = 3x^2
       mul first_r, first_r, x_r                                // first_r = 3x^3
       madd y_r, first_r, x_r, y_r                              // y_r = 0 + 3x^4

       mov second_r, -287                                       // register for value -287  from equation (-287x^2)
       mul second_r, second_r, x_r                              // second_r = -287x
       madd y_r, second_r, x_r, y_r                             // y_r = y_r - 287x^2

       mov third_r, -63                                         //register for value -63  from equation (-63x)
       madd y_r, third_r, x_r, y_r                              // y_r = y_r  - 63x
       add y_r, y_r, 37                                         // add the constant value of 37 from the equation

       cmp loop_r, 0                                            // Compare loop count with  0
       b.eq setymin                                             // If loop count = 0 branch off to setymin

       cmp y_r, miny_r                                          // Compare y value to minimum y value
       b.lt setymin                                             // if y value < min y value,branch to setymin

loop:
       adrp x0, fmt                                             // setting first argument  of printf

       add x0, x0, :lo12:fmt                                    // add  12 bits to x0
       mov x1, x_r                                              // x1 = x_r for printf
       mov x2, y_r                                              // x2 = y_r for prinf
       mov x3, miny_r                                           // x3 = miny_r  for printf

       bl printf                                                // call printf function
       add loop_r, loop_r, 1                                    // add 1 to loop counter everytime the loop is run
       add x_r, x_r, 1                                          // add 1 to the x value in range (-10,10)
       b pre_loop                                               // branches off to pre_loop to see if new value in within (-10,10)

setymin:
       mov miny_r, y_r                                          // miny_r = y_r
       b loop                                                   // branch off to loop  for value to ve orinted

pre_loop:
      cmp x_r, 10                                               // compares x to maximum range in (-10,10)
      b.le loop_test                                            // branches off to loop_test if x_r < 10

last:
     mov x0, 0                                                  // set return code to 0
     ldp  x29, x30, [sp], 16                                    //cleans up lines, restores the stack

     ret                                                        // return to OS
