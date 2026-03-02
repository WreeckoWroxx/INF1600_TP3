/*
Signature: void applyPhosphor(applyScanline& p, int percent);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
percent : facteur d’assombrissement

Description : Cette fonction applique un facteur d’assombrissement à un pixel en multipliant chacune de ses composantes RGB par un pourcentage donné: nouvelle_valeur = valeur_orignale x percent / 100
*/    
.data 

percent_conversion: 
.int 100

.text 
.globl applyScanline                      

applyScanline:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # Callee-saved push
    pushl %esi
    pushl %ebx
    
    # TODO
    
    movl 8(%ebp), %esi # addr vers p
    movl 12(%ebp), %ebx # pourcentage
    movl $3, %ecx
    
    rgb_modif:
    movl -1(%esi, %ecx, 1), %eax
    mull %ebx

    xorl %edx, %edx
    divl percent_conversion

    movb %al, -1(%esi, %ecx, 1)
    loop rgb_modif

    # Callee-saved pop
    popl %ebx
    popl %esi

    # epilogue
    leave 
    ret   

