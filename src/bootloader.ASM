BITS 16

_boot equ 0x7e00

halt_on_error:
    pusha
    pushf
    pop bx
    and bx, 0x1
    jz ret
    hlt

    ret:
        popa
        ret

start:
    mov ah, 0   ; set video
    mov al, 3   ; 80x25 text mode
    int 0x10    ; calling video interrupt
    call halt_on_error

    ; Enabling Protected Mode (32 bit)
    pushf
    pop ax
    or ax, 0x1
    mov cr0, eax

    ;jmp _boot
    hlt
; bios call signature
;times 510 - ($ - $$) db 0
;dw 0xAA55