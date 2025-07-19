section .data
    even_msg db "Even", 0xA       ; "Even\n"
    even_len equ $ - even_msg

    odd_msg db "Odd", 0xA         ; "Odd\n"
    odd_len equ $ - odd_msg

section .text
    global _start

;-----------------------------------------
; Function: _check_even_odd
; Description: Receives one number from the stack
;              Checks if even or odd using AND
;              Prints "Even" or "Odd" accordingly
;-----------------------------------------
_check_even_odd:
    push ebp                ; Save old base pointer
    mov ebp, esp            ; Set new base pointer
    sub esp, 4              ; Reserve space for local variable (not strictly needed, but follows lecture pattern)

    mov eax, [ebp+8]        ; Get the function argument from stack
    and eax, 1              ; Isolate the last bit (0 if even, 1 if odd)
    cmp eax, 0
    je print_even

print_odd:
    mov eax, 4              ; syscall: sys_write
    mov ebx, 1              ; file descriptor: stdout
    mov ecx, odd_msg        ; message
    mov edx, odd_len        ; length
    int 0x80
    jmp done_check

print_even:
    mov eax, 4
    mov ebx, 1
    mov ecx, even_msg
    mov edx, even_len
    int 0x80

done_check:
    leave                   ; Equivalent to mov esp, ebp and pop ebp
    ret                     ; Return to caller

;-----------------------------------------
; Program Entry Point
;-----------------------------------------
_start:
    mov eax, 10             ; Assign number to register (you can change to test)
    push eax                ; Pass number to function
    call _check_even_odd    ; Call the function

    ; Exit system call
    mov eax, 1              ; syscall: exit
    xor ebx, ebx            ; exit code 0
    int 0x80
