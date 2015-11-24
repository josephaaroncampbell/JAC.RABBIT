::Created by Joseph Aaron Campbell
::Copyright 2015


::turn off command prompt reporting
::@echo off

::create subfolders
MD "%~dp0source"
MD "%~dp0output"
MD "%~dp0raw"

::create text files
dir "%~dp0output" /b/O:N > output.txt
dir "%~dp0source" /b/O:N > source.txt

