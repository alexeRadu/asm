org 100h

	mov al, 00h
	call set_video_mode	; set video mode to  40x25, 16 colors
             
    call laddr2chs
    mov al, 1           ; read one sector
    mov dl, 0           ; from FLOPPY_0
    lea bx, sector      ; into "sector" buffer
    call read_sect
    
    ; save BIOS parameter block
    add bx, 0bh         ; go to bios parameter block
    mov si, bx          ; move to src
    
    lea di, bytes_per_sector
    mov cx, 0dh         
    
    call memcpy
    
    ; print bytes per sector
    lea bx, msg_bytes_per_sector
    call print

    lea di, value
    mov ax, WORD PTR [bytes_per_sector]
    call word2str
    mov bx, di
    call print

    lea bx, msg_enter
    call print

    ; print sectors per cluster
    lea bx, msg_sectors_per_cluster
    call print
    
    lea di, value
    mov al, [sectors_per_cluster]
    call byte2str
    
    mov bx, di
    call print
    
    lea bx, msg_enter
    call print
    
	jmp $			; jump to the same location

	msg_bytes_per_sector	db	'bytes per sector: ', 0
	msg_sectors_per_cluster db  'sectors per cluster: ', 0
	msg_enter db 0dh, 0

	value db    16 dup(0)
	
	bytes_per_sector        dw  0
	sectors_per_cluster     db  0
	reserved_sectors        dw  0
	fat_count               db  0
	max_root_dir_entries    dw  0
	sector_count            dw  0
	media_descriptor        db  0
	sectors_per_fat         dw  0
	
	sectors_per_track       db  0
	tracks_per_cylinder     db  0

; convert a byte to string
; al [in]       - byte to be converted
; es:di [out]   - ptr to dst string
byte2str:
    pusha

    mov cx, 4           ; clear 3 digits and a null char
    call zeromem

    add di, 2           ; move to first digit position
    mov bl, 10          ; base 10

.byte2str_loop:             
    mov ah, 0           ; clear the rest from previous loop
    cmp ax, 0           ; see if last divide was zero
    je .byte2str_end    ; if so, goto end
    div bl              ; ax / bl = al rest ah
    add ah, 30h         ; convert digit to string (30h = '0')
    mov [di], ah        ; save digit
    dec di              ; go to next digit pointer
    jmp .byte2str_loop
    
.byte2str_end:
    inc di                      ; move the di to point to the first non-zero char
    mov [_byte2str_tmp], di     ; save di
    popa
    mov di, [_byte2str_tmp]     ; restore di
    ret
    
    _byte2str_tmp dw    0


; convert a word to string
word2str:
    pusha
                        ; max value on 16 bits is 65536 (on 5 chars)
    mov cx, 6           ; clear 5 digits and a null char 
    call zeromem

    add di, 4           ; move to first digit position
    mov bx, 10          ; base 10

.word2str_loop:
    mov dx, 0           ; clear the rest from previous loop
    cmp ax, 0           ; see if last divide was zero
    je .word2str_end    ; if so, goto end
    div bx              ; (dx, ax) / bx = ax rest dx
    add dx, 30h         ; convert digit to string (30h = '0')
    mov [di], dl        ; save digit
    dec di
    jmp .word2str_loop

.word2str_end:
    inc di                      ; move the di to point to the first non-zero char
    mov [_word2str_tmp], di     ; save di
    popa
    mov di, [_word2str_tmp]     ; restore di
    ret

    _word2str_tmp   dw      0



; convert logical sector to head, cilinder, sector
; ax [in]   - sector index (from 0)
; ch [out]  - cylinder number (0..79)
; dh [out]  - head number (0..1)
; cl [out]  - sector number (1..18)	
laddr2chs:
    mov ch, 0
    mov dh, 0
    mov cl, 1
    ; TODO: implement complete logic
    ret
    
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
include mem.asm

sector:
