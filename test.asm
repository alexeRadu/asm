org 100h

	mov al, 00h
	call set_video_mode	; set video mode to  40x25, 16 colors
    
    mov al, 0
    mov ch, 0
    mov cl, 1
    mov dh, 0
    mov dl, 0
    lea bx, sector
    call read_sect

	jmp $			; jump to the same location

	msg	db	'Hello there', 0dh


; read a disk sector to memory
; al [in]   - number of sectors to read
; ch [in]   - cylinder number (0..79)
; cl [in]   - sector number (1..18)
; dh [in]   - head number (0..1)
; dl [in]   - drive number
; es:bx [out] - data buffer
read_sect:
    pusha

    mov ah, 2
    int 13h
    
    popa
    ret

    
include io.asm

    sector db 0