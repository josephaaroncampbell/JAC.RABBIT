::Created by Joseph Aaron Campbell
::http://josephaaroncampbell.com
::Copyright 2015

@echo off
  
  rem create counter
  set counter=0

  rem ask user for input of raw file type
  SET /P rawFormat=Please type the RAW FORMAT of your camera (letters only ex: cr2, nef, orf...)  and then press ENTER:

  rem ask user for input of dpi
  SET /P dpi=Please type the desired DPI for 'tiff' output file and then press ENTER:

  rem ask user for input of sequential naming prefix
  SET /P namePfx=Please type the desired prefix for the file naming and then press ENTER:

  rem ask user for input of file name
  SET /P nameNumber=Please type the starting number for sequential file name and then press ENTER:

  rem ask user for input of sequential number increment
  SET /P nameInc=Please type the increment for sequential file naming and then press ENTER:

  rem ask user for input if color target will be added
  SET /P targetBool=Please type 'yes' if you want the color target added and 'no' if not and then press ENTER:

  rem set amount to extend the canvas by later in script
  set removeDpi=%dpi%

  rem if user prompts 'no' for adding target then set canvas extension to zero
  IF %targetBool%==no (
   echo bool is set
   set /a "removeDpi=%dpi%*0"
  )
   echo removeDpi=%removeDpi%

  :start
  
  echo returning the list of source files.. 
  FORFILES /p %~dp0source\ /s /m "*.%rawFormat%" /C "cmd /c echo @path" > source.txt
  IF %ERRORLEVEL% EQU 1 goto :else
  
  echo join source and output data, returning files shared in common..
  findstr /I /L /G:"source.txt" "output.txt" > found.txt
  IF %ERRORLEVEL% EQU 1 copy /y source.txt notFound.txt
  
  echo join found file names and source filenames, returning those that do not have a match
  findstr /I /L /V /G:"found.txt" "source.txt" >> notFound.txt
  IF %ERRORLEVEL% EQU 2 echo error no match
  
  echo for each file not found do..
  for /f %%n in (notFound.txt) do (
    echo n=%%n
    call :dequote %%n
  )

  :dequote
  setlocal EnableDelayedExpansion 
  set fullPath=%~f1
  set fileName=%~n1
  set fileExt=%~x1
  set filePath=%~dp1
  set name=%fileName%& set npath=%filePath%& set ext=%fileExt%& set fpath=%fullPath%
  cd %nPath%

  IF NOT [%1]==[] (
      echo pull jpeg thumbnail from raw file
      dcraw -w -e !name!!ext!

      echo get width, height, and density of !name!!ext! thumbnail
      for /f %%c in ('identify -quiet -ping -format %%w !name!.thumb.jpg') do (set origWidth=%%c)
      for /f %%d in ('identify -quiet -ping -format %%h !name!.thumb.jpg') do (set origHeight=%%d)

      echo set 'half' variables for RGB point extraction option
      set /a "halfHeight=!origHeight!/2"
      set /a "halfWidth=!origWidth!/2"

      echo taking RGB reading of center point for each image edge: top bottom right left
      for /f %%e in ('identify -quiet -format "%%[fx:int(255*p{!halfWidth!,0}.g)]" !name!.thumb.jpg') do (set top=%%e)
      for /f %%f in ('identify -quiet -format "%%[fx:int(255*p{!halfWidth!,!origHeight!}.g)]" !name!.thumb.jpg') do (set bottom=%%f)
      for /f %%g in ('identify -quiet -format "%%[fx:int(255*p{!origWidth!,!halfHeight!}.g)]" !name!.thumb.jpg') do (set right=%%g)
      for /f %%h in ('identify -quiet -format "%%[fx:int(255*p{0,!halfHeight!}.g)]" !name!.thumb.jpg') do (set left=%%h)

      echo resampling the target image to !dpi! dpi and saving into temporary file
      convert target.tif -quiet -colorspace RGB -background white -resample !dpi! -units pixelsPerInch target-temp.tif

      echo getting the height of the temporary target 
      for /f %%m in ('identify -quiet -ping -format %%h target-temp.tif') do (set tHeight=%%m)

      echo calculating where to place target into %name%%ext%
      set /a "placeTarget=!dpi!/2-!tHeight!/2"

      echo rotate image based on which edge is 'black'
      IF !bottom! LEQ 70 (
       set pixelXY=!origHeight!
       set /a "stopLoop=!origHeight!/4"
       FOR /L %%i IN (0,1,!stopLoop!) DO (
        for /f %%k in ('identify -quiet -format "%%[fx:int(255*p{!halfWidth!,!pixelXY!}.g)]" !name!.thumb.jpg') do (set tempRGB=%%k)
        set /a "pixelXY=!pixelXY!-15"
        set /a chopped=!origHeight!-!pixelXY!
        IF !tempRGB! GTR 200 (goto :rotateBottom)
       )
       :rotateBottom
       echo removing vignette,set dpi, convert to grayscale, make 8bit, invert, remove black edge, rotate then save !name!
       echo name will be: !namePfx!!nameNumber! and increment=!nameInc!
       convert -quiet flatfield.tiff !name!!ext! -compose Divide -composite -density !dpi! -units pixelsPerInch -depth 8 -colorspace gray -negate -gravity south -chop 0x!chopped! -splice 0x!removeDpi! !namePfx!!nameNumber!.tif
       echo adding orignal raw filename to output tiff
       exiftool -keywords+=!name!!ext! !namePfx!!nameNumber!.tif 
       PING -n 3 127.0.0.1>nul
       IF %targetBool%==yes (composite -colorspace gray -background white -gravity south -geometry +0+!placeTarget! target-temp.tif !namePfx!!nameNumber!.tif !namePfx!!nameNumber!.tif)
       PING -n 3 127.0.0.1>nul
       move !namePfx!!nameNumber!.tif %~dp0output
       move %name%%ext% %~dp0raw
       del !name!.thumb.jpg
       cd %~dp0
       goto :reset
      )
   
      IF !left! LEQ 70 (
       set pixelXY=
       set /a "stopLoop=!origWidth!/4"
       FOR /L %%i IN (0,1,!stopLoop!) DO (
        for /f %%k in ('identify -quiet -format "%%[fx:int(255*p{!pixelXY!,!halfHeight!}.g)]" !name!.thumb.jpg') do (set tempRGB=%%k)
        set /a "pixelXY=!pixelXY!+15"
        set /a chopped=!pixelXY!
        IF !tempRGB! GTR 200 (goto :rotateLeft)
       )
       :rotateLeft
       echo remove vignette,set dpi, convert to grayscale, make 8bit, invert, remove black edge, rotate then save !name!
       convert -quiet flatfield.tiff !name!!ext! -compose Divide -composite -density !dpi! -units pixelsPerInch -depth 8 -colorspace gray -negate +level 5%%,95%%,1.0 -gravity west -chop !chopped!x0 -rotate -90  -gravity south -splice 0x!removeDpi! !namePfx!!nameNumber!.tif
       echo adding orignal raw filename to output tiff
       exiftool -keywords+=!name!!ext! !namePfx!!nameNumber!.tif 
       PING -n 3 127.0.0.1>nul
       IF %targetBool%==yes (composite -colorspace gray -background white -gravity south -geometry +0+!placeTarget! target-temp.tif !namePfx!!nameNumber!.tif !namePfx!!nameNumber!.tif)
       PING -n 3 127.0.0.1>nul
       move !namePfx!!nameNumber!.tif %~dp0output
       move %name%%ext% %~dp0raw
       del !name!.thumb.jpg
       cd %~dp0
       goto :reset
      )

      IF !top! LEQ 70 (
       set pixelXY=
       set /a "stopLoop="!origHeight!/4"
       FOR /L %%i IN (0,1,!stopLoop!) DO (
        for /f %%j in ('identify -quiet -format "%%[fx:int(255*p{!halfWidth!,!pixelXY!}.g)]" !name!.thumb.jpg') do (set tempRGB=%%j)
        set /a "pixelXY=!pixelXY!+15"
        set chopped=!pixelXY!
        IF !tempRGB! GTR 200 (goto :rotateTop)
       ) 
       :rotateTop
       echo remove vignette,set dpi, convert to grayscale, make 8bit, invert, remove black edge, rotate then save !name!
       convert -quiet flatfield.tiff !name!!ext! -compose Divide -composite -density !dpi! -units pixelsPerInch -depth 8 -colorspace gray -negate +level 5%%,95%%,1.0 -gravity north -chop 0x!chopped! -rotate 180  -gravity south -splice 0x!removeDpi! !namePfx!!nameNumber!.tif
       echo adding orignal raw filename to output tiff
       exiftool -keywords+=!name!!ext! !namePfx!!nameNumber!.tif 
       PING -n 3 127.0.0.1>nul
       IF %targetBool%==yes (composite -colorspace gray -background white -gravity south -geometry +0+!placeTarget! target-temp.tif !namePfx!!nameNumber!.tif !namePfx!!nameNumber!.tif)
       PING -n 3 127.0.0.1>nul
       move !namePfx!!nameNumber!.tif %~dp0output
       move %name%%ext% %~dp0raw
       del !name!.thumb.jpg
       cd %~dp0
       goto :reset
      ) 

      IF !right! LEQ 70 (
       set pixelXY=!origWidth!
       set /a "stopLoop=!origWidth!/4!
       FOR /L %%i IN (0,1,!stopLoop!) DO (
        for /f %%k in ('identify -quiet -format "%%[fx:int(255*p{!pixelXY!,!halfHeight!}.g)]" !name!.thumb.jpg') do (set tempRGB=%%k)
        set /a "pixelXY=!pixelXY!-15"
        set /a chopped=!origWidth!-!pixelXY!
        IF !tempRGB! GTR 200 (goto :rotateRight)
       )
       :rotateRight
       echo remove vignette,set dpi, convert to grayscale, make 8bit, invert, remove black edge, rotate then save !name!
       convert -quiet flatfield.tiff !name!!ext! -compose Divide -composite -density !dpi! -units pixelsPerInch -depth 8 -colorspace gray -negate +level 5%%,95%%,1.0 -gravity east -chop !chopped!x0 -rotate 90  -gravity south -splice 0x!removeDpi! !namePfx!!nameNumber!.tif
       echo adding orignal raw filename to output tiff
       exiftool -keywords+=!name!!ext! !namePfx!!nameNumber!.tif 
       PING -n 3 127.0.0.1>nul
       IF %targetBool%==yes (composite -colorspace gray -background white -gravity south -geometry +0+!placeTarget! target-temp.tif !namePfx!!nameNumber!.tif !namePfx!!nameNumber!.tif)
       PING -n 3 127.0.0.1>nul
       move !namePfx!!nameNumber!.tif %~dp0output
       move %name%%ext% %~dp0raw
       del !name!.thumb.jpg
       cd %~dp0
       goto :reset
       )

  :reset
  copy /y source.txt > output.txt
  del notFound.txt
  del found.txt
  del target-temp.tif
  set /a "counter=!counter!*0 
  set /a "nameNumber=!nameNumber!+!nameInc!"
  goto :start
  
  ) ELSE ( 

  :else
  cd %~dp0
  goto :countDown

  ) 

  :countDown
  set /a "counter=%counter%+1"
  echo There are no new raw files to edit!
  PING -n 2 127.0.0.1>nul
  IF %counter% GEQ 500 call :exitBatch 
  goto :start

  :exitBatch
  echo exit program
  del output.txt
  del source.txt
  exit 


