//Author: Vidhi Soni 
//Date: March 12th, 2022
//
//Description:
// This is an ARMv8 program that implements the C code provided in the assignment.It is written in nano.
// It implements structs and nested structs, subroutines in assembly, pointers as arguments to subroutines, and returns structs by value from functions.

       print_Box: .string "Box %s origin = (%d, %d) width = %d height = %d area = %d\n"  //Formats output as string
       initial_p: .string "Initial Box Values:\n"                                        //Formats output as string and prints initial box values
       first_p:   .string "first"                                                        //Formats output as string and prints first struct box
       second_p:  .string "second"                                                       //Formats output as string and prints second struct box
       changed_p: .string "\Changed box values:\n"                                       //Formats output as string and prints changed box values

       x_s = 0                                                                           //x_s (offset for int x) = 0
       y_s = 4                                                                           //y_s (offset for int y) = 4
       width_s = 8                                                                       //width_s (offset for int width) = 8
       height_s = 12                                                                     //height_s (offset for int height) = 12
       area_s = 16                                                                       //area_s (offset for int area) = 16

       box_size = 20                                                                     //Box_size = 20
       result_size = 4                                                                   //size of int variable size
       result_s = 16                                                                     //result_s (offset for int result) = 16
       first_s =  16                                                                     //first_s (offset  for first box) = 16
       second_s = first_s + box_size                                                     //second_s (offset for second box) = first box offset + box size

       FALSE = 0                                                                         //FALSE = 0
       TRUE = 1                                                                          //TRUE = 1

       alloc = -(16 + (box_size * 2)) & -16                                              //Memory allocation for two boxes
       dealloc = -alloc                                                                  //Memory deallocation for two boxes

       equal_alloc = (-16 + result_size) & -16                                           //Memory allocation for equal
       equal_dealloc = -equal_alloc                                                      //Memory deallocation for equal

       newBox_alloc = -(16 + box_size) & -16                                             //Memory allocation for newBox
       newBox_dealloc = -newBox_alloc                                                    //Memory deallocation for newBox

       .balign 4                                                                         //Ensures the next instruction's address is divisible by 4

newBox_method:
       stp x29, x30, [sp, newBox_alloc]!                                                 //Allocate memory for newBox
       mov x29, sp                                                                       //Update FP to top of the stack

       add x9, fp, box_size                                                              //x9 = fp + box_size
       str xzr, [x9, x_s]                                                                //var x_s = 0
       str xzr, [x9, y_s]                                                                //var y_s = 0
       mov w10, 1                                                                        //w10 = 1
       str w10, [x9, width_s]                                                            //width_s = 1
       str w10, [x9, height_s]                                                           //height_s = 1

       ldr w10, [x9, width_s]                                                            //w10 = width_s
       ldr w11, [x9, height_s]                                                           //w11 = height_s
       mul w10, w11, w10                                                                 //w10 = w10(width_s) * w11(height_s)
       str w10, [x9, area_s]                                                             //w10 = area_s

       ldr w10, [x9, x_s]                                                                //Loads register with value x_s
       str w10, [x8, x_s]                                                                //Stores adress in x8
       ldr w10, [x9, y_s]                                                                //Load register with value y_s
       str w10, [x8, y_s]                                                                //Stores adress in x8
       ldr w10, [x9, width_s]                                                            //Loads register with value width_s
       str w10, [x8, width_s]                                                            //Stores adressin x9
       ldr w10, [x9, height_s]                                                           //Loads adress in x9
       str w10, [x8, height_s]                                                           //Stores adress in x8
       ldr w10, [x9, area_s]                                                             //Loads register with value height_s
       str w10, [x8, area_s]                                                             //Store adress in x8

       ldp x29, x30, [sp], newBox_dealloc                                                //Deallocate memory
       ret                                                                               //Return to main

move_method:
       stp fp, lr, [sp, -16]!                                                            //Allocate memory
       mov fp, sp                                                                        //Update FP to top of the stack

       ldr w9, [x0, x_s]                                                                 //w9 = x_s
       add w9, w9, w1                                                                    //w9 =  w9 + w1
       str w9, [x0, x_s]                                                                 //w9 = x_s
       ldr w9, [x0, y_s]                                                                 //w9 = y_s
       add w9, w9, w2                                                                    //w9 = w9 + w2
       str w9, [x0, y_s]                                                                 //w9 = y_s

       ldp x29, x30, [sp], 16                                                            //Deallocate memory
       ret                                                                               //Return to main

expand_method:
       stp x29, x30, [sp, -16]!                                                          //Allocate memory
       mov x29, sp                                                                       //Update FP to top of the stack

       ldr w9, [x0, width_s]                                                             //w9 = width_s
       mul w9, w9, w1                                                                    //w9 = w9 * w1
       str w9, [x0, width_s]                                                             //w9 = width_s
       ldr w9, [x0, height_s]                                                            //w9 = height_S
       mul w9, w9, w1                                                                    //w9 = w9 * w1
       str w9, [x0, height_s]                                                            //w9 = height_s
       ldr w10, [x0, width_s]                                                            //w10 = width_s
       mul w9, w9, w10                                                                   //w9 = w9 *  w10
       str w9, [x0, area_s]                                                              //w9 = area_s

       ldp x29, x30, [sp], 16                                                            //Deallocate memory
       ret                                                                               //Return to main

printBox:
       stp fp, lr, [sp, -16]!                                                            //Allocate memory
       mov fp, sp                                                                        //Update the FP to the top of the stack

       ldr x2, [x1, x_s]                                                                 //x2 = x_s
       ldr x3, [x1, y_s]                                                                 //x3 = y_s
       ldr x4, [x1, width_s]                                                             //x4 = width_s
       ldr x5, [x1, height_s]                                                            //x5 = height_s
       ldr x6, [x1, area_s]                                                              //x6 = area_s

       mov x1, x0                                                                        //x1 = x0
       adrp x0, print_Box                                                                //Setting first argument of function  printf
       add x0, x0, :lo12:print_Box                                                       //Add 12 bits to x0
       bl printf                                                                         //Call printf function

       ldp x29, x30, [sp], 16                                                            //Deallocate memory
       ret                                                                               //Return to main

equal_method:
       stp x29, x30, [sp, equal_alloc]!                                                  //Allocate memory
       mov x29, sp                                                                       //Update FP to the top of the stack

       mov w9, FALSE                                                                     //w9 = FALSE
       str w9, [x29, result_s]                                                           //Store result_s in memory

       ldr w10, [x0, x_s]                                                                //w10 = x_s (first)
       ldr w11, [x1, x_s]                                                                //w11 = x_s (second)
       cmp w10, w11                                                                      //Compare x_s (first) to x_s (second)
       b.ne end_eq                                                                       //Branch to end_eq if they are not the same

       ldr w10, [x0, y_s]                                                                //w10 = y_s (first)
       ldr w11, [x1, y_s]                                                                //w11 = y_s (second)
       cmp w10, w11                                                                      //Compare y_s (first) to y_s (second)
       b.ne end_eq                                                                       //Branch to end_eq if they are not the same

       ldr w10, [x0, width_s]                                                            //w10 = width_s (first)
       ldr w11, [x1, width_s]                                                            //w11 = width_s (second)
       cmp w10, w11                                                                      //Compare width_s (first_ to width_s (second)
       b.ne end_eq                                                                       //Branch to end_eq if they are not the same

       ldr w10, [x0, height_s]                                                           //w10 = height_s (first)
       ldr w11, [x1, height_s]                                                           //w11 = height_s (second)
       cmp w10, w11                                                                      //Compare height_s (first) to height_s (second)
       b.ne end_eq                                                                       //Branch to end_eq if they are not the same

       mov w9, TRUE                                                                      //w9 = TRUE
       str w9, [x29, result_s]                                                           //Store result_s in memory
       ldr w0, [x29, result_s]                                                           //Load result_s

end_eq:
       ldp x29, x30, [sp], 16                                                            //Deallocate memory
       ret                                                                               //Return

       .global main                                                                      //Enables main value to be visible to the linker

main:
       stp x29, x30, [sp, alloc]!                                                        //Allocate  memory
       mov x29, sp                                                                       //Set FP to the top of the stack

       add x8, x29, first_s                                                              //x8 = fp + first_s (offset)
       bl newBox_method                                                                  //Branch to  newBox_method

       add x8, x29, second_s                                                             //x8 = fp + second_s (offset)
       bl newBox_method                                                                  //Branch to newBox_method

       adrp x0, initial_p                                                                //Setting first argument of printf
       add x0, x0, :lo12:initial_p                                                       //Add 12 bits to x0
       bl printf                                                                         //Call printf function

       adrp x0, first_p                                                                  //Setting first argument for printBox
       add x0, x0, :lo12:first_p                                                         //Add 12 bits to x0
       add x1, x29, first_s                                                              //x1 = fp
       bl printBox                                                                       //Branch to printBox

       adrp x0, second_p                                                                 //Setting first argument for printBox
       add x0, x0, :lo12:second_p                                                        //Add 12 bits to x0
       add x1, x29, second_s                                                             //x1 = fp
       bl printBox                                                                       //Branch to printBox

       add x0, x29, first_s                                                              //x0 = fp + first_s (offset)
       add x1, x29, second_s                                                             //x1 = fp + second_s (offset)
       bl equal_method                                                                   //Branch to equal_method
       cmp w0, FALSE                                                                     //Compare w0 to FALSE
       b.eq last                                                                         //Branch to last if result = FALSE(0)

       add x0, x29, first_s                                                              //x0 = fp + first_s (offset)
       mov w1, -5                                                                        //w1 = -5
       mov w2, 7                                                                         //w2 = 7
       bl move_method                                                                    //Branch to move_method

       add x0, x29, second_s                                                             //x0 = fp + second_s (offset)
       mov w1, 3                                                                         //w1 = 3
       bl expand_method                                                                  //Branch to expand_method

last:
       adrp x0, changed_p                                                                //Setting first argument of function printf
       add x0, x0, :lo12:changed_p                                                       //Add 12 bits to x0
       bl printf                                                                         //Call printf function

       adrp x0, first_p                                                                  //Setting first argument for printBox
       add x0, x0, :lo12:first_p                                                         //Add 12 bits to x0
       add x1, x29, first_s                                                              //x1 = fp + first_s (offset)
       bl printBox                                                                       //Branch to printBox

       adrp x0, second_p                                                                 //Setting first argument for printBox
       add x0, x0, :lo12:second_p                                                        //Add 12 bits to x0
       add x1, x29, second_s                                                             //x1 = fp + second_s (offset)
       bl printBox                                                                       //Branch to printBox

       ldp x29, x30, [sp], dealloc                                                       //Deallocate memory
       ret                                                                               //Return to OS
