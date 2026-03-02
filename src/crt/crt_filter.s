/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter                      

crtFilter:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp       

    movl 8(%ebp), %esi # addr de Image& dans esi

    # TODO
    xorl %ecx, %ecx # compteur pour rangee
    boucle_y: # ligne
    cmpl %ecx, 4(%esi)
    jz fin 

    movl 8(%esi, %ecx, 4), %ebx # MARCHE PAS

    xorl %edx, %edx # compteur pour colonne
    boucle_x: # colonne
    cmpl %edx, (%esi)
    jz prochain_y

    movl (%ebx, %edx, 4), %edi # MARCHE PAS

    pushl %edx # compteur de colonne

    movl %edx, %eax
    xorl %edx, %edx
    divl 12(%ebp) # Division par scanlineSpacing
    cmpw $0, %dx
    popl %edx
    jnz no_scanline

    pushl %edx
    pushl %ecx # sauvegarde de ecx   
    pushl less_color # push des argumens
    pushl %edi
    call applyScanline
    addl $8, %esp
    popl %ecx
    popl %edx

    no_scanline:
    movl %edx, %eax # move compteur de colonne (edx) dans eax pour division

    xorl %edx, %edx
    divl max_index
    pushl %edx # caller-saved
    pushl %ecx
    pushl %edx # push des arguments
    pushl %edi
    call applyPhosphor
    addl $8, %esp

    popl %ecx 
    popl %edx

    incl %edx
    jmp boucle_x

    prochain_y:
    incl %ecx
    jmp boucle_y
    
    fin:
    # epilogue
    leave 
    ret 

