
; zero out memory
; es:di [in]    - pointer to memory
; cx            - byte count
zeromem:
    push ax
    mov al, 0
    call memset
    pop ax
    ret


; set memory to a certain value
; es:di [in]    - pointer to destination
; cx            - byte count
; al            - value
memset:
    pusha

.memset_loop:
    cmp cx, 0
    je .memset_end
    stosb
    dec cx
    jmp .memset_loop

.memset_end:
    popa
    ret

	
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
