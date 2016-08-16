org 100h

	mov al, 00h
	call set_video_mode	; set video mode to  40x25, 16 colors

	lea bx, msg
	call print

	jmp $			; jump to the same location

	msg	db	'Hello there', 0dh, 'How are you?', 0

; change the video mode
; al [in]	- (00h, 03h, 13h) the desired video mode
set_video_mode:
	pusha
	mov ah, 0
	int 10h
	popa
	ret
	

; print a char to the console
; al [in] 	- char to be printed
putch:
	pusha
	mov ah, 0eh
	int 10h

	cmp al, 0dh		; in case a CR was detected
	jne .putch_end
	mov al, 0ah		; insert a LF as well
	int 10h

.putch_end:
	popa
	ret

; print a string to the console
; bx [in] 	- string to be printed
print:
	pusha			; save all registers

.print_loop:
	mov al, [bx]
	cmp al, 0
	je .print_end
	call putch
	inc bx
	jmp .print_loop:

.print_end:
	popa
	ret
