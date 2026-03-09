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
    movl 8(%ebp), %ebx # x
    movl 12(%ebp), %ecx # y
    movl 16(%ebp), %eax # size
    movl 20(%ebp), %edi # img
    movl 24(%ebp), %esi # color

    Verification_borne:
    cmpl (%edi), %ebx
    jge fin

    Pixel_drawing:
    cmpl $1, %eax
    jnz suite

    pushl %edi

    #movl %edi, %edx
    addl $8, %edi
    movl (%edi), %edx

    # movl (%edx), %edi
    addl %ecx, %edx
    movl (%edx), %edi
    addl %ebx, %edi
    movl %esi, %edi

    popl %edi

    jmp fin

    // movl (%edi), %edx
    # Vieu truc marche pas
    // pushl %edi
    // movl %edi, %edx
    // addl $8, %edx # edx -> Pixel[0][]
    // movl %edx, %edi
    // movl (%edi), %edx
    // movl %edx, %edi
    // addl %ecx, %edi
    // movl (%edi), %edx  # edx -> Pixel[y][]
    // addl %ebx, %edx  # edx -> Pixel[y][x]
    // movl %esi, %edx
    // popl %edi
    // jmp fin

    suite:
    xorl %edx, %edx
    divl halve # size -> half

    #Lower left triangle
    pushl %esi
    pushl %edi
    pushl %eax
    addl %eax, %ecx # y + half
    pushl %ecx
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp

    #Lower right triangle
    pushl %esi
    pushl %edi
    pushl %eax
    addl %eax, %ebx # x + half
    pushl %ecx
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp


    # top triangle
    pushl %esi
    pushl %edi
    pushl %eax
    subl %eax, %ecx # y + half -> y
    pushl %ecx

    pushl %eax
    xorl %edx, %edx
    movl $2, %eax
    divl %ebx
    movl %eax, %ebx
    popl %eax

    pushl %ebx
    call sierpinskiImage
    addl $20, %esp

    fin:
    # epilogue
    leave 
    ret   

