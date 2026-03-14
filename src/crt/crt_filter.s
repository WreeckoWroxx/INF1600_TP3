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

    # TODO
    movl 8(%ebp), %esi # addr de Image& dans esi
    movl (%esi), %edx # largeur : nb de colonnes
    movl 4(%esi), %ecx # hauteur : compteur pour rangee
    
    movl 8(%esi), %edi # Pixel**

    boucle_y: # rangee, utilise loop et ecx
    movl -4(%edi, %ecx, 4), %ebx # passer a la rangee de pixels suivantes
    xorl %eax, %eax # reset compteur pour colonne

    boucle_x: # colonne, utilise edx comme max et eax comme compteur
    cmpl %eax, %edx
    jz prochain_y
    
    leal (%ebx, %eax, 4), %esi # mettre l'adresse du pixel suivant de la rangee dans esi

    # Verification horizontale pour applyScanline
    pushl %eax # sauver le compteur de colonne
    pushl %edx # sauver le nb de colonnes
    xorl %edx, %edx
    movl %ecx, %eax
    subl $1, %eax # ecx va de max a 1, donc on soustrait 1 pour verifier les lignes max-1 a 0
    divl 12(%ebp) # Division du compteur de rangee (ecx) par scanlineSpacing
    cmpw $0, %dx
    popl %edx
    popl %eax
    jnz no_scanline

    # applyScanline
    pushl %edx # push caller-saved
    pushl %ecx
    pushl %eax
    pushl less_color # push des arguments
    pushl %esi
    call applyScanline
    addl $8, %esp # ignorer les arguments dans la pile
    popl %eax # pop caller-saved
    popl %ecx
    popl %edx

    no_scanline:
    pushl %eax # sauver le compteur de colonne
    pushl %edx # sauver le nb de colonnes
    xorl %edx, %edx
    divl max_index

    pushl %ecx # push caller-saved
    pushl %edx # push des arguments
    pushl %esi
    call applyPhosphor
    addl $8, %esp # ignorer les arguments dans la pile
    popl %ecx # pop caller-saved
    popl %edx
    popl %eax

    incl %eax
    jmp boucle_x

    prochain_y:
    loop boucle_y

    # epilogue
    leave 
    ret 

