#JAC.RABBIT#

A rapid digitization workflow utilizing Windows command language, ImageMagick, and Exiftool. This workflow was created in response to a massive digitization project of Nitrate Negatives and the lack of needed equipment and standard commercial software designed for rapid capture photography. It is designed to be open source and for Museums or Cultural Heritage institutions that do not have the resources to produce or purchase a state of the art digitization system. The workflow is currently designed for transparent black and white negatives of any format and material. 

This is done through a windows batch file that continuously checks for new RAW images in a specific folder. The code is windows command language , ImageMagick, and Exiftool parsed through the command line. After proper setup when your camera sends a new raw image to a source or ‘hot folder’ it will first determine the auto rotation anchor by checking each image frame edge to see if it contains a black edge. This process is described in the wiki at  [Set Up Image Frame/Auto Rotate Edges](https://github.com/josephaaroncampbell/JAC.RABBIT/wiki/Workflow#set-up-image-frame-and-auto-rotate-image-edges). 

Then the software will convert the raw image and output a ‘.tif’ file. During this conversion the file is inverted, auto rotated, converted to grayscale, the black edge is removed, vignette/flatfield corrections are applied, and  saved with a unique serialized file name based off of user input. Finally, the original raw image file name is stored in the keyword field of the new tiff image using ExifTool.


### EQUIPMENT USED:

-Canon 5D MKIII with EF 50mm 1:2.5 Macro Lens  
-Manfrotto Mini Salon Camera Stand  
-Dell Alienware Laptop  
-Porta-Trace / Gagne LED Light Panel (18 x 24", Black)   
-Generic Laptop Stand  
-Two 6in x 2in Black Matte Board Pieces ( size will vary based on size of object to be digitized)  


### SOFTWARE USED:  

1. Canon EOS Utility    
2. Canon Digital Photo Professional 4    
3. Custom Windows Software (Batch files)    
a. ‘Setup.bat’ : Creates all the needed folders and files to run the automated service.    
b. ‘Flatfield.bat’ : Creates the flat field tiff image from a source raw file needed to apply flatfield/vignette removal  c. ‘jacRabbit.bat’ : monitors source folder for new RAW images. Completes the following actions for each RAW image:  
 1. user input for raw type, file name, dpi, and other info  
 2. continuously checks for new raw images in source hot folder  
 3. locate black edge for auto rotation  
 4. apply flatfield correction  
 5. set density (dpi)    
 6. 8 bit depth  
 7. set colorspace to grayscale  
 8. invert from positive to negative   
 9. remove black edge pixels  
 10. rotate image based on which edge is black.  
 11. onvert to tiff with unique file name  
 12. embeds original raw file name into new tiff image  
 13. moves edited raw images to backup raw folder  
 14. moves created tiff images to separate output folder  
4. _ImageMagick_ : handles all raw image manipulation and conversion. Its raw engine is dcRaw.  
     i. <http://www.imagemagick.org/script/index.php> 
5. _Exiftool_ : extracts and embeds metadata  
     i. <http://www.sno.phy.queensu.ca/~phil/exiftool/> 


