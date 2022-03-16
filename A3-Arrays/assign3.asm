//Author: Vidhi Soni 
//Date: March 1st, 2022
//
//Description:
// This is an ARMv8 program that sorts a one-dimensional array, using m4 macros or assembler equates for all stack variable offsets.It also makes use of stack to store local variables, and adressing
// stack variables.The program is written in nano, with array size 50.

       values_print:  .string "v[%d]: %d\n"                                //Formats all output as string and prints each line in the array
       sorted_print:  .string "\nSorted Array: \n"                         //Formats all output as string and prints the sorted array statement

       SIZE = 50                                                           //Size of array given in assignment document
       v_size = 4*SIZE                                                     //Allocates 4*50 = 200 bytes in memory for array
       v_s = 28                                                            //Stack offset 28  for v

       temp_size =  4                                                      //Size of int variable temp is 4 bytes
       temp_s = 24                                                         //Stack offset 24 for temp

       i_size =  4                                                         //Size of int variable i is 4 bytes
       i_s = 16                                                            //Stack offset 20 for i

       j_size = 4                                                          //Size of int variable j is 4 bytes
       j_s = 20

       alloc = -(16 + i_size + j_size + temp_size + v_size) & -16          //Memory Allocation
       dealloc = -alloc                                                    //Memory Deallocation

       fp .req x29						                                             //Rename x29 as fp
       lr .req x30						                                             //Rename x30 as lr

       .balign 4                                                           //Next instructions adress is divisible by 4
       .global main                                                        //Enables main label to be visible to linker

main:
       stp fp, lr, [sp,alloc]!                                             //Save frame pointer and link register to stack
       mov fp, sp                                                          //Update FP to the top of stack

       define(base_r, x20)                                                 //base_r = x20
       define(temp_r, w21)                                                 //temp_r = w21
       define(ls_r, w22)                                                   //ls_r = w22
       add base_r, fp, v_s                                                 //base_r = fp offset + v_s

       mov ls_r, 0                                                         //ls_r = 0
       str ls_r, [fp, i_s]                                                 //Initialize i to 0
       b check_one                                                         //Branch to check_one to see if i > SIZE

loop_one:
       bl rand                                                             //Branch to rand to generate random numbers
       and temp_r, w0, 0xFF                                                //Number generated will be between 0-255
       str temp_r, [base_r, ls_r, SXTW 2]                                  //v[i] = temp_r

       adrp x0, values_print                                               //Setting first argument for function printf
       add x0, x0, :lo12:values_print                                      //Add 12 bits to x0
       mov w1, ls_r                                                        //ls_r = w1
       mov w2, temp_r                                                      //temp_r = w2
       bl printf                                                           //Call printf function

       add ls_r, ls_r, 1                                                   //i = i + 1
       str ls_r, [fp, i_s]                                                 //Store i in memory

check_one:
       cmp ls_r, SIZE                                                      //Compares i to SIZE
       b.lt loop_one                                                       //If i < SIZE, branches to loop_one

       mov ls_r, 1                                                         //ls_r = 1
       str ls_r, [fp, i_s]                                                 //Initialize i to 1
       b check_two                                                         //Branch to check_two, which compares i to SIZE

loop_two:
       ldr temp_r, [base_r, ls_r, SXTW 2]                                  //v[1] = temp_r
       str temp_r, [fp, temp_s]                                            //v[i] = temp_r

       ldr ls_r, [fp, i_s]                                                 //ls_r = i
       str ls_r, [fp, j_s]                                                 //Initialize i to j
       b check_three                                                       //Branch to check_three, which checks whether to rerun loop

loop_three:
       ldr ls_r, [fp, j_s]                                                 //ls_r = j
       sub ls_r, ls_r, 1                                                   //ls_r = j-1
       ldr temp_r, [base_r, ls_r, SXTW 2]                                  //Load v[j-1] to temp_r

       add ls_r, ls_r, 1                                                   //ls_r = j
       str temp_r, [base_r, ls_r, SXTW 2]                                  //v[j-1] tp temp_r
       sub ls_r, ls_r, 1                                                   //ls_r = j-1
       str ls_r, [fp, j_s]                                                 //Store new value of j into memory

check_three:
       ldr ls_r, [fp, j_s]                                                 //ls_r = j
       cmp ls_r, 0                                                         //Compares ls_r to 0
       b.le after_loop                                                     //If ls_r < 0, branches to after_loop

       ldr temp_r, [fp, temp_s]                                            //temp_r = temp
       sub w22, ls_r, 1                                                    //w22 = j-1
       ldr w23, [base_r, w22, SXTW 2]                                      //w23 = v[j-1]

       cmp temp_r, w23                                                     //Compare temp to value in register w23
       b.ge after_loop                                                     //If temp > 0, branch to after_loop
       b loop_three                                                        //If temp < 0, and ls_r > 0, branch to loop_three

after_loop:
       ldr ls_r, [fp, temp_s]                                              //Load temp_s to ls_r
       ldr temp_r, [fp, j_s]                                               //Load j_s to temp_r
       str ls_r, [base_r, temp_r, SXTW 2]                                  //v[j] = temp

       ldr ls_r, [fp, i_s]                                                 //Load i_s to ls_r
       add ls_r, ls_r, 1                                                   //i = i+1
       str ls_r, [fp, i_s]                                                 //Store i value into memory

check_two:
       cmp ls_r, SIZE                                                      //Compare ls_r (i) to SIZE
       b.lt loop_two                                                       //If i< SIZE, then branch to loop_two

       adrp x0, sorted_print                                               //Setting first argument of function printf
       add x0, x0, :lo12:sorted_print                                      //Add 12 bits to x0
       bl printf                                                           //Call printf function

       mov ls_r, 0                                                         //ls_r =  0
       str ls_r, [fp, i_s]                                                 //Store ls_r (i) into memory
       b end                                                               //Branch to end (end of program)

loop_end:
      adrp x0, values_print                                                //Set first argument of function printf
      add x0, x0, :lo12:values_print                                       //Add 12 bits to x0
      mov w1, ls_r                                                         //w1 = ls_r

      ldr temp_r, [base_r, ls_r, SXTW 2]                                   //v[i] = temp_r
      mov w2, temp_r                                                       //w2 = temp_r
      bl printf                                                            //Call printf function

      add ls_r, ls_r, 1                                                    //ls_r (i) = ls_r (i) + 1
      str ls_r, [fp, i_s]                                                  //Store i value in memory

end:
      cmp ls_r, SIZE                                                       //Compare ls)_r (i) to SIZE
      b.lt loop_end                                                        //If i < SIZE, branch to loop_end

      mov w0, 0                                                            //Set return code to 0
      ldp fp, x30, [sp], dealloc                                           //Cleans up lines, restores the stack
      ret                                                                  //Return to OS
