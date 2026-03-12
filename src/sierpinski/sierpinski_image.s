/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

halve: .int 2

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    # Variables locales: 3
    subl $12, %esp

    movl 8(%ebp), %ebx # x
    movl 12(%ebp), %ecx # y
    movl 16(%ebp), %eax # size
    movl 20(%ebp), %edi # img aka Image&
    movl 24(%ebp), %edx # color aka Pixel

    # Verification des bornes
    cmpl (%edi), %ebx
    jge fin
    cmpl 4(%edi), %ecx
    jge fin

    # Pixel drawing
    cmpl $1, %eax
    jnz suite

    # Sauvegarder les valeurs des arguments
    pushl %eax
    movl 8(%edi), %esi # acceder a Pixel**
    movl (%esi, %ecx, 4), %eax # acceder au bon tableau Pixel*[]
    leal (%eax, %ebx, 4), %esi # esi contient maintenant l'adresse du pixel a modifier
    #movl (%esi), %eax # TEST POUR VOIR VALEURS RGB DE PIXEL: Avant
    movl %edx, (%esi) # changer couleur
    #movl (%edi), %eax # TEST POUR VOIR VALEURS RGB DE PIXEL: Apres
    popl %eax

    # TEST POUR VOIR VALEURS RGB DE PIXEL
/*
    pushl %edi # Image&
    pushl %eax

    movl 8(%edi), %esi # acceder a Pixel**
    movl (%esi, %ecx, 4), %eax # acceder au bon tableau Pixel*[]
    leal (%eax, %ebx, 4), %esi # edi contient maintenant l'adresse du pixel a modifier

    #movl %edx, (%esi) # changer couleur
    
    movl (%esi), %eax # TEST POUR VOIR VALEURS RGB DE PIXEL: Apres

    popl %eax
    popl %edi # remettre Image& dans edi
*/
    jmp fin



    suite:
    pushl %edx
    xorl %edx, %edx
    divl halve # size -> half
    popl %edx


    # LOWER LEFT TRIANGLE
    pushl %edx
    pushl %edi
    pushl %eax
    # var locale 1: y + half
    pushl %ecx
    addl %eax, %ecx
    movl %ecx, -4(%ebp)
    popl %ecx
    # push var locale:
    pushl -4(%ebp)
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp


    # LOWER RIGHT TRIANGLE
    pushl %edx
    pushl %edi
    pushl %eax
    pushl -4(%ebp)
    # var locale 2: x + half
    pushl %ebx
    addl %eax, %ebx
    movl %ebx, -8(%ebp)
    popl %ebx
    # push var locale:
    pushl -8(%ebp)
    call sierpinskiImage
    addl $20, %esp


    # TOP TRIANGLE
    pushl %edx
    pushl %edi
    pushl %eax
    pushl %ecx
    # var locale 3: x + (half / 2)
    pushl %eax
    pushl %edx
    pushl %ebx
    xorl %edx, %edx
    divl halve # half / 2
    addl %eax, %ebx
    movl %ebx, -12(%ebp) # x + (half / 2)
    popl %ebx
    popl %edx
    popl %eax
    # push var locale
    pushl -12(%ebp)
    call sierpinskiImage
    addl $20, %esp



    fin:
    # epilogue
    leave
    ret