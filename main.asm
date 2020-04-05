include macros.asm

.model small

; STACK SEGMENT
.stack

; DATA SEGMENT
.data

; CODE SEGMENT
.code

main proc

    mov ax, @data
    mov ds, ax

main endp

end