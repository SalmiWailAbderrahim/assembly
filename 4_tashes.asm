;=================================================================
                            ;le data
;=================================================================
data segment
    msg0 db "deroutement fait .....$"
    msg1 db 0ah,0dh,0ah,0dh,"tache1 en cours d'execution$"
    msg2 db 0ah,0dh,"tache2 en cours d'execution$"
    msg3 db 0ah,0dh,"tache3 en cours d'execution$"
    msg4 db 0ah,0dh,"tache4 en cours d'execution$"

    ;5s=5000ms  la 1ch execute chack 55ms donc
    cpt0 dw 91d ;x=5000/55=90.9
    cpt1 dw 1
    cpt2 dw 2
    cpt3 dw 3
    cpt4 dw 4
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
;   affiche1 et affiche2 et affiche3 et affiche4 respictivement
                ;   chaque 5 second 
;=========================================================
   new:
        mov ax,seg cpt0
        mov ds,ax
        dec cpt0
        jnz sortie
        mov cpt0,91d
        dec cpt1
        jnz here2
        call affiche1
        mov cpt1,4
  here2:dec cpt2
        jnz here3
        call affiche2
        mov cpt2,4
  here3:dec cpt3
        jnz here4
        call affiche3
        mov cpt3,4
  here4:dec cpt4
        jnz sortie
        call affiche4
        mov cpt4,4
        
 sortie:iret

;=================================================================
;   les procedure affiche pour afficher telle tache est en cours d'execution 
;=================================================================                             
    affiche1 proc near
        mov ax,seg msg1
        mov ds,ax
        mov dx,offset msg1
        mov ah,09
        int 21h
        ret
        affiche1 endp
     affiche2 proc near
        mov ax,seg msg2
        mov ds,ax
        mov dx,offset msg2
        mov ah,09
        int 21h
        ret
        affiche2 endp
     affiche3 proc near
        mov ax,seg msg3
        mov ds,ax
        mov dx,offset msg3
        mov ah,09
        int 21h
        ret
        affiche3 endp
     affiche4 proc near
        mov ax,seg msg4
        mov ds,ax
        mov dx,offset msg4
        mov ah,09
        int 21h
        ret
        affiche4 endp
    
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
encore:jmp encore;boucle infini
    
    mov ax,4c00h
    int 21h
code ends
end start 
