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
    obiwan.jpg: https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.pinterest.com%2Fpin%2Fewan-mcgregor-aka-obi-wan-kenobi-motorcycle-enthusiast--22799541847685800%2F&ved=0CBYQjRxqFwoTCNivm7b9n5MDFQAAAAAdAAAAABAe&opi=89978449
    zelda.png: https://pixelatedarcade.s3.us-east-005.dream.io/screenshots/2506/2624/screenshot_e50-the-legend-of-zelda-exploring-hyrule.png
*/

.data 

inputCrt: 
    .asciz "images/obiwan.jpg"

scanlineSpacing:
    .int 2

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
    subl $12, %esp
    movl %esp, %eax
    pushl %eax # caller-saved: référence vers Image
    pushl %eax # push des arg
    pushl $inputCrt
    call loadImage
    addl $8, %esp

    popl %eax # reprendre la référence vers Image
        
    # TODO: Appliquer le filtre crtFilter() sur cette image
    pushl %eax # caller-saved
    pushl scanlineSpacing # push des arg
    pushl %eax
    call crtFilter
    addl $8, %esp

    popl %eax # reprendre la référence vers Image

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    pushl %eax # caller-saved
    pushl %eax # push des arg
    pushl $outputCrt
    call saveImage
    addl $8, %esp

    popl %eax

    # TODO: Libérer la mémoire de vos images avec freeImage()
    pushl %eax
    call freeImage
    addl $4, %esp
    

    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    subl $12, %esp
    movl %esp, %eax
    pushl %eax

    pushl taille # push des arguments
    pushl taille
    pushl %eax
    call createImage
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puis push l’adresse de cet espace comme 3e paramètre avant de call la fonction.
    addl $12, %esp

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    pushl %eax # garder dans la pile la reference vers img

    # push des arguments
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

    pushl %eax # push des arguments
    pushl $outputSierpinski
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    popl %eax

    pushl %eax # push des arguments
    call freeImage
    addl $4, %esp
    addl $4, %esp # enlever la reference vers l'image de la pile


    movl    $0, %eax
    # epilogue
    leave 
    ret