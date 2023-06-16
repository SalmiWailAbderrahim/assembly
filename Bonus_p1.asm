;=================================================================
                            ;le data
;=================================================================
data segment
    msg0 db "deroutement fait .....",0ah,0dh,"$"
    msg01 db 0ah,0dh,"recupiration fait .....","$"
    msg1 db 0ah,0dh,'****programme principal en cours****$'
    msg2 db 'oh, la 1ch ...... $' 
    ;5min=300000ms la 1ch execute chack 55ms donc
    cmpt dw 15dfh ;x=300000/55=5455
    cpt dw 3
    cm dw 20
    ancienCS dw
    ancienIP dw
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
;   affiche chaque second et s'arrete apres 5 min
;=========================================================
    new:
        mov ax,seg cpt
        mov ds,ax
        dec cmpt
        jz near ptr derout2;si cmpt=0 (donc il past 5min) on jmp a derout2
        dec cpt
        jnz sortie
        call affiche
        mov cpt,18
        dec cm
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
    
;=================================================================
;   la procedure derouter qui deroute la 1ch a sont ancien routin
;=================================================================
    derout2 PROC near
        push ds
        mov ds,ancienCS
        mov dx,ancienIP
        mov ax, 251Ch
        int 21h
        pop ds
        mov dx,offset msg01
        mov ah,09
        int 21h
        jmp near ptr thend
     derout2     ENDP

;=========================================================
               ;Le programme principale 
;=========================================================  
start:            
    mov ax,data
    mov ds,ax
    mov ax,pile
    mov ss,ax
    mov sp,offset tos
      
    ; recupiration de ancian ip et cs
;-----------------------------------------
    mov ah,35h
    mov al,1ch
    int 21h
    mov ancienCS,es
    mov ancienIP,bx
          
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
    
    
    call derout2
thend:mov ax,4c00h
    int 21h
code ends
end start 
