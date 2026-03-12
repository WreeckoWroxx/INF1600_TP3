/*
    Vous pouvez modifier le liens des images. SVP mettre leur source si pris en ligne.

    Commandes:

	make : compile le projet en générant l’exécutable principal.
	make run : compile le projet (si nécessaire) puis exécute l’application.
	make test : lance la suite de tests prévue pour vérifier le bon fonctionnement des fonctions et filtres implémentés.
	make remise : crée un fichier zip contenant l’ensemble des fichiers nécessaires pour la remise du projet, prêt à être soumis.

    Sources:
    shrek.jpg: https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DHLQ1cK9Edhc&ved=0CBYQjRxqFwoTCOCi0sel3pIDFQAAAAAdAAAAABAK&opi=89978449
    shrek2.jpg: https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fnews.sky.com%2Fstory%2Fdonkey-that-inspired-eddie-murphys-character-in-shrek-dies-aged-30-13283911&ved=0CBYQjRxqFwoTCMjFkPWc3pIDFQAAAAAdAAAAABAH&opi=89978449
    shrek3.jpg: https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.cornel1801.com%2Fanimated%2FShrek-2001%2Fpart-4-looking-for-the-princess-find-a-girl-dragon.html&ved=0CBYQjRxqFwoTCJiYj4qd3pIDFQAAAAAdAAAAABBY&opi=89978449

*/

.data 

inputCrt: 
    # TEST
    .asciz "sierpinski.png"
    #.asciz "images/shrek.jpg"

scanlineSpacing:
    .int 10

outputCrt:
    .asciz "crt.png"

outputSierpinski:
    .asciz "sierpinski.png"

taille:
    .int 1024


.text 
.globl main                      

main:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
/*
    pushl %esp
    pushl $inputCrt
    call loadImage
        
    movl 4(%esp), %eax
    # TODO: Appliquer le filtre crtFilter() sur cette image
    #addl $8, %esp
    pushl scanlineSpacing
    pushl %eax
    call crtFilter
    popl %eax
    addl $4, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    pushl %eax
    pushl $outputCrt
    call saveImage
    addl $4, %esp
    popl %eax

    # TODO: Libérer la mémoire de vos images avec freeImage()
    pushl %eax
    call freeImage
    addl $4, %esp
*/
    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()

    subl $12, %esp
    movl %esp, %eax
    pushl %eax
    pushl taille
    pushl taille
    pushl %eax
    call createImage
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puis push l’adresse de cet espace comme 3e paramètre avant de call la fonction.
    addl $12, %esp

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    pushl %eax # garder dans la pile la reference vers img

    # TEST COULEUR DE PIXEL
/*
    #movl 8(%eax), %eax # vérification que 8(%eax) = Pixel**
    movl 8(%eax), %esi # acceder a Pixel**
    #movl (%edi), %esi
    movl 4(%esi), %eax # acceder au bon tableau Pixel*[]
    leal 4(%eax), %esi # edi contient maintenant l'adresse du pixel a modifier
    
    // addl %ecx, %esi
    // movl (%esi), %edi
    // addl %ebx, %edi

    movl (%esi), %eax # TEST POUR VOIR VALEURS RGB DE PIXEL: Avant

    popl %eax
    pushl %eax
*/
    # FIN TEST

    # Push un pixel de couleur arbitraire
    // pushb $255 # alpha
    // pushb $0 # blue
    // pushb $255 # green
    // pushb $0 # red
    pushl $0xFF0000FF # pixel rouge
    pushl %eax
    pushl taille
    pushl $0
    pushl $0
    call sierpinskiImage
    addl $20, %esp

    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()
    popl %eax
    pushl %eax

    # TEST COULEUR DE PIXEL
/*
    #movl 8(%eax), %eax # vérification que 8(%eax) = Pixel**
    movl 8(%eax), %esi # acceder a Pixel**
    #movl (%edi), %esi
    movl 4(%esi), %eax # acceder au bon tableau Pixel*[]
    leal 4(%eax), %esi # edi contient maintenant l'adresse du pixel a modifier
    
    // addl %ecx, %esi
    // movl (%esi), %edi
    // addl %ebx, %edi

    movl (%esi), %eax # TEST POUR VOIR VALEURS RGB DE PIXEL: Avant

    popl %eax
*/
    # FIN TEST

    pushl %eax
    pushl $outputSierpinski # argument
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    popl %eax
    pushl %eax
    call freeImage
    addl $4, %esp
    addl $4, %esp # enlever la reference vers l'image de la pile


    movl    $0, %eax
    # epilogue
    leave 
    ret