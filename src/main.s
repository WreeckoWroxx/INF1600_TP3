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
    .asciz "images/shrek.jpg"

scanlineSpacing:
    .int 10

outputCrt:
    .asciz "crt.png"

outputSierpinski:
    .asciz "sierpinski.png"


.text 
.globl main                      

main:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()

    pushl %esp
    pushl $inputCrt
    call loadImage
        
    # push esp (addr vers image loadée) dans un registre pour sauvegarder référence vers l'image (?)
    
    # TODO: Appliquer le filtre crtFilter() sur cette image
    pushl scanlineSpacing
    pushl %esp
    call crtFilter

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()

    # TODO: Libérer la mémoire de vos images avec freeImage()

    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puit push l’adresse de cet espace comme 3e paramètre avant de call la fonction.

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()

    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()

    # TODO: Libérer la mémoire de vos images avec freeImage()




    movl    $0, %eax
    # epilogue
    leave 
    ret   
