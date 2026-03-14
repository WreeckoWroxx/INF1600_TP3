/*
Signature: void applyPhosphor(Pixel& p, int subpixel);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
subpixel : indice du pixel dominant

Description : Le paramètre subpixel détermine quelle composante reste dominante :
	si subpixel == 0 → le rouge est conservé, le vert et le bleu sont réduits à 70 % de leur valeur initiale.
	si subpixel == 1→ le vert est conservé, le rouge et le bleu sont réduits à 70 % de leur valeur initiale.
	sinon → le bleu est conservé, le rouge et le vert sont réduits à 70 % de leur valeur initiale.

Encore une fois, puisqu’on travaille avec des divisions entières, la réduction se fait avec la formule suivante : nouvelle_valeur = valeur_originale × 70 / 100


*/
.data 

offset:
    .int 3

factor:
    .int 70

percent_conversion: 
    .int 100
        
.text 
.globl applyPhosphor                      

applyPhosphor:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # Callee-saved push
    pushl %esi
    pushl %ebx

    # TODO
    movl 8(%ebp), %esi # addr du pixel
    movl 12(%ebp), %ebx # subpixel

    xorl %eax, %eax

    # verif composante rgb a garder
    cmpl $0, %ebx
    jz conserver_rouge

    cmpl $1, %ebx
    jz conserver_vert

    # conserver bleu:
    movb (%esi), %al # couleur r du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, (%esi)

    movb 1(%esi), %al # couleur g du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, 1(%esi)

    jmp epilogue

    conserver_rouge:
    movb 1(%esi), %al # couleur g du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, 1(%esi)

    movb 2(%esi), %al # couleur b du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, 2(%esi)

    jmp epilogue

    conserver_vert:
    movb (%esi), %al # couleur r du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, (%esi)

    movb 2(%esi), %al # couleur b du pixel dans al
    mull factor
    xorl %edx, %edx
    divl percent_conversion
    movb %al, 2(%esi)

    epilogue:
    # callee-saved pop
    popl %ebx
    popl %esi
    
    leave 
    ret   

