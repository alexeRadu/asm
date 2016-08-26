org 100h

	mov al, 00h
	call set_video_mode	; set video mode to  40x25, 16 colors
             
    call laddr2chs
    mov al, 1           ; read one sector
    mov dl, 0           ; from FLOPPY_0
    lea bx, sector      ; into "sector" buffer
    call read_sect
    
    add bx, 0bh         ; go to bios parameter block
    mov si, bx          ; move to src
    
    lea di, bytes_per_sector
    mov cx, 0dh         
    
    call memcpy

    
    

	jmp $			; jump to the same location

	msg	db	'Hello there', 0
	
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
	
; copy memory from source to destination
; ds:si [in]    - src
; cx            - byte count
; es:di [out]   - dst
memcpy:
    pusha

.memcpy_loop:
    cmp cx, 0
    je .memcpy_end
    lodsb
    stosb
    dec cx
    jmp .memcpy_loop

.memcpy_end:
    popa
    ret

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

sector: