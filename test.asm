org 100h

	mov al, 00h
	call set_video_mode	; set video mode to  40x25, 16 colors

	lea bx, msg
	call print
	
	lea di, resp
	call scan

	jmp $			; jump to the same location

	msg	db	'Hello there', 0dh, 'How are you?', 0dh, 0
	resp	db	64 dup(0)

include io.asm