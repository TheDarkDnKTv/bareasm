BITS 16

_boot equ 0x7e00

start:
    mov ah, 0   ; set video
    mov al, 3   ; 80x25 text mode
    int 0x10    ; calling video interrupt
    ;call halt_on_error

    ; Enabling Protected Mode (32 bit)
    xor eax, eax   ; clear eax
    mov eax, cr0   ; copy control register to eax (OR not working ;( )
    or ax, 0x1     ; enabling protected mode flag
    cli ; interrupts disabled
    mov cr0, eax
    
    ;sti

    jmp $
    ;jmp _boot

halt_on_error:
    pusha
    pushf
    pop bx
    and bx, 0x1
    jnz power_off
    popa
    ret

power_off:
    ; Checking configuration
    mov ah, 53h     ; this is an APM command
    mov al, 00h     ; installation check command
    xor bx, bx      ; device id (0 = APM BIOS)
    int 15
    jc halt

    ; disconnect from any APM interface
    mov ah, 53h
    mov al, 04h     ; interface disconnect command
    xor bx, bx
    int 15h
    jnc .no_error

    ; if error
    cmp ah, 03h     ; if the error code is anything but 03h there was an error.
    jne halt

    ; connect to real mode interface
    .no_error:
    mov ah, 53h
    mov al, 01h     ; real mode interface
    xor bx, bx
    int 15h
    jc halt

    ; Enable power management for all devices
    mov ah, 53h
    mov al, 08h     ; Change the state of power management...
    mov bx, 0001h   ; ...on all devices to...
    mov cx, 0001h   ; ...power management on.
    int 15h
    jc halt

    ; Set the power state for all devices
    mov ah, 53h
    mov al, 07h     ; Set the power state...
    mov bx, 0001h   ; ...on all devices to...
    mov cx, 03h     ; Powet Off
    int 15h
    jc halt

halt:
    cli
    hlt