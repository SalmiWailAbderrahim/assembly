;=================================================================
                            ;le data
;=================================================================
data segment
    msg0 db "deroutement fait .....",0ah,0dh,"$"
    msg1 db 0ah,0dh,'****programme principal en cours****$'
    msg2 db 'oh, la 1ch ...... $' 
    ;1s=1000ms  la 1ch execute chack 55ms donc
    cpt dw 18;x=1000/55=18
    cm dw 20
data ends
;=================================================================
                            ;la pile
;=================================================================
pile segment stack
    dw 128 dup(?)
    tos label word
pile ends
;=================================================================
                            ;le code
;=================================================================
code SEGMENT
    Assume CS:code , DS:data , SS:pile
   
;=================================================================
;   la procedure derouter qui fait le deroutement de la routin 1ch 
;=================================================================
     derouter PROC near
        push ds
        mov ax,seg new
        mov ds,ax
        mov dx, offset new
        mov ax, 251Ch
        int 21h
        pop ds
        mov dx,offset msg0
        mov ah,09
        int 21h
        ret
    derouter     ENDP
    
;=========================================================
;   le nouvelle routine qui fait un appelle a la procedure
;   affiche chaque second
;=========================================================
    new:
        mov ax,seg cpt
        mov ds,ax
        dec cpt
        jnz sortie
        call affiche
        mov cpt,18
        dec cm;a chaque fois en affish un msg on dec cm par 1
    sortie:iret

;=================================================================
;   la procedure affiche pour afficher le msg oh, la 1ch.... 
;=================================================================                             
    affiche proc near
        mov ax,seg msg2
        mov ds,ax
        mov dx,offset msg2
        mov ah,09
        int 21h
        ret
    affiche endp
    
;=========================================================
               ;Le programme principale 
;=========================================================    
start:            
    mov ax,data
    mov ds,ax
    mov ax,pile
    mov ss,ax
    mov sp,offset tos
    
    call derouter
    
    
again:mov ax,seg msg1
    mov ds,ax
    mov dx,offset msg1
    mov ah,09
    int 21h
    mov cx,0ffffh
    mov cm,20
    boucle_externe: mov si,0fffh
    boucle_interne: dec si
    jnz boucle_interne
    test cm,0ffffh;on test si cm=0 ou nn 
    jz again;si zf=0 on affish le msg ****programme principal en cours****
    loop boucle_externe
    
    mov ax,4c00h
    int 21h
code ends
end start 
