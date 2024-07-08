ORG 0
BITS 16

jmp 0x7c0:start

start:
    cli ; Clear interrupts
    mov ax, 0x7c0 ; We have to put the starting location into AX before moving it into the data segment or extra segment
    mov ds, ax
    mov es, ax

    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    sti ; Enables interrupts
    mov si, message
    call print
    jmp $   ; Infinite loop to halt execution

print: 
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop

.done:    
    ret

print_char:
    mov ah, 0eh ; Move 0e to the high byte
    int 0x10    ; Interrupt which tells the BIOS to print the character pointed by AL
    ret

message: db 'Hello Lens_r!', 0
times 510-($ - $$) db 0 ; Fill 510 bytes of memory with 0
dw 0xAA55 ; Writes the boot signature (0x55AA since x86 is little endian)