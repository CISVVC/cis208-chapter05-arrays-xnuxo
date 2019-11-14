; Name: asm_main.asm
; Developer: Jude McParland
; Email: judem6968@student.vvc.edu
; Date: 11/13/19
; Description:  A program that iterates and multiplies by a scalar across an array.
;               As it multiplies, it stores the result in the index it multiplied with, then prints.

%include "asm_io.inc"
; ******************************************************
;
; FXN: asm_main
; Param(s): None
; Description:  C-Callable main assembly func. Initializtion
;
; ******************************************************

segment .data
        msg     dd  "Iterating and multiplying by scalar (5) across array[1,2,3,4,5].", 0
        msg2    dd  "Storing product(s) in respective index. Results[0-4]:", 0
        array   dw  1, 2, 3, 4, 5      

segment .text
        global  asm_main
asm_main:
        enter   0,0                 ; setup routine
        pusha

; Messages (Printing)

        call    print_nl
        mov     eax, msg            ; Prints starting info message.
        call    print_string
        call    print_nl
        mov     eax, msg2           ; Prints result info message.
        call    print_string
        call    print_nl
        call    print_nl

; We're going to push the raw params to the stack.

        push    DWORD 5             ; Param3: Scalar of array   (SCLR)
        push    DWORD 5             ; Param2: Size of array     (SIZE)
        push    DWORD array         ; Param1: Loc of array      (ADDR)
        call    proc_array          ; Call proc_array FXN below.
        add     esp, 12             ; Remove Params from stack.

        call    print_nl
        popa
        leave                     
        ret

; ******************************************************
;
; FXN: proc_array (ASSEMBLY ONLY | C-Calling not required.)
; Param(s): LOC (Array), SIZE, SCALAR – Note: Pushed in reverse like C-Calling.
; Description:  This will iterate over the array provided and will 
;               multiply each entry by the scalar storing the 
;               result in the corresponding entry. Prints the 
;               product stored at array[n] after storage there.
;
; ******************************************************

segment .text
        global  proc_array
proc_array:
        push    ebp
        mov     ebp, esp
        mov     ebx, [ebp+8]        ; ebx=LOC
        mov     ecx, [ebp+12]       ; ecx=SIZE

    loop_on_me:
        mov     ax, [ebx]           ; ax = *array[n]
        movzx   dx, [ebp+16]        ; dx = SCALAR
        imul    dx                  ; ax = ax * dx
        mov     [ebx], ax           ; *array[n] = ax

        movzx   eax, word [ebx]    ; Output method requirements not specified so I printed as such.
        call    print_int
        call    print_nl
        add     ebx, 2
        loop    loop_on_me

        mov     esp, ebp
        pop     ebp
        ret
