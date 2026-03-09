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
    movl 8(%esi), %ebx # pointeur vers tableau de tableaux de pixels: Pixel** Pixel[][] MARCHE PAS
    #movl (%ebx), %ebx # dereferencer le pointeur vers le tableau de tableaux de pixels

    boucle_y: # rangee, utilise loop et ecx
    movl -4(%ebx, %ecx, 4), %esi # pointeur vers tableau de pixels MARCHE PAS (overwrite esi: contient pointeur vers Pixel[] au lieu de Image&)
    xorl %eax, %eax # compteur pour colonne

    boucle_x: # colonne
    cmpl %eax, %edx
    jz prochain_y
    movl (%esi, %eax, 4), %edi # pointeur vers un pixel MARCHE PAS

    pushl %eax # sauver le compteur de colonne
    pushl %edx # sauver le nb de colonnes

    # Verification pour applyScanline
    xorl %edx, %edx
    divl 12(%ebp) # Division du compteur de colonnes (eax) par scanlineSpacing
    cmpw $0, %dx
    popl %edx
    popl %eax
    jnz no_scanline

    pushl %edx # push caller-saved
    pushl %ecx
    pushl %eax
    pushl less_color # push des arguments
    pushl %edi
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
    pushl %edi
    call applyPhosphor
    addl $8, %esp # ignorer les arguments dans la pile
    popl %ecx # pop caller-saved
    popl %edx
    popl %eax

    incl %eax
    jmp boucle_x

    prochain_y:
    loop boucle_y
    
    fin:
    # epilogue
    leave 
    ret 

