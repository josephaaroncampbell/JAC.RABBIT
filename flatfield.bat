::Created by Joseph Aaron Campbell
::http://josephaaroncampbell.com
::Copyright 2015

dcraw -T -w -d -b 0.9 -g 1 1 flatfield.cr2
move /y flatfield.tif %~dp0/source
 

