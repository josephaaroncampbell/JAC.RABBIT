#JAC.RABBIT#

>A rapid digitization workflow utilizing windows command language, ImageMagick, and Exiftool. This workflow was created in response to a massive digitization project of Nitrate Negatives and the lack of needed equipment and standard commercial software designed for rapid capture photography. It is designed to be open source and for Museums or Cultural Heritage institutions that do not have the resources to produce or purchase a state of the art digitization system.
>
>This is done through a windows batch file that continuously checks for new RAW images in a specific folder. The code is windows command language , ImageMagick, and Exiftool parsed through the command line. After proper setup when your camera sends a new raw image to a source or ‘hot folder’ it will first determine the auto rotation anchor by checking each image frame edge to see if it contains a black edge. This process is described in 'ReadMe - Using the Auto Rotate Function'. 
>
>Then the software will convert the raw image and output a ‘.tif’ file. During this conversion the file is inverted, auto rotated, converted to grayscale, the black edge is removed, vignette/flatfield corrections are applied, and  saved with a unique serialized file name based off of user input. Finally, the original raw image file name is stored in the keyword field of the new tiff image using ExifTool.


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
 b. ‘Flatfield.bat’ : Creates the flat field tiff image from a source raw file needed to apply flatfield/vignette removal  
 c. ‘jacRabbit.bat’ : monitors source folder for new RAW images. Completes the following actions for each RAW image:  
      1.   user input for raw type, file name, dpi, and other info  
      2.  continuously checks for new raw images in source hot folder  
      3. locate black edge for auto rotation  
      4.  apply flatfield correction  
      5.   set density (dpi)    
      6.  8 bit depth  
      7. set colorspace to grayscale  
      8. invert from positive to negative   
      9.  remove black edge pixels  
      10.   rotate image based on which edge is black.  
      11.  convert to tiff with unique file name  
      12. embeds original raw file name into new tiff image  
      13. moves edited raw images to backup raw folder  
      14. moves created tiff images to separate output folder  
4. ImageMagick : handles all raw image manipulation and conversion. Its raw engine is dcRaw.  
     i. http://www.imagemagick.org/script/index.php  
5. Exiftool : extracts and embeds metadata  
     i. http://www.sno.phy.queensu.ca/~phil/exiftool/  

### SETUP PHYSICAL WORKSPACE:  
1. Work area should be clean of dirt, grime, or other unwanted elements  
2. Basic setup will consist of object, object support, camera, camera stand, laptop, tether software, and a  light table/box  
3. Place the camera on the camera stand or tripod  
4. Using a pitch finder or level, measure the angles parallel between the camera lens and object surface (do not measure on the actual object, measure the table to whatever is supporting the object). Make sure the camera lens matches the angle of the light table/box.  
5. Place laptop nearby on stand or other support surface  
6. Power on both the camera and the laptop  
7. On the camera:  
1. turn off any special white balance  
2. turn off timers and ensure the camera is on ‘single shutter’ mode  
3. turn on AutoFocus for the lens if applicable, otherwise use manual focus  
8. Connect the camera to the usb cable  
9. Connect the opposite end of the usb cable to the computer  



![Alt text](/readMeGRFX/BlackHorizontal.png?raw=true "Black Strip Horizontal")
