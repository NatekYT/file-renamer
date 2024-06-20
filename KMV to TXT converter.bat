@echo off
setlocal enabledelayedexpansion

REM Get the current directory
set "directory=%cd%"

REM Define the list of file extensions to exclude
set excludeExtensions=doc docx one ppt pptx odt ods odp pdf txt jpg png

REM Get the name of this script without the extension
set "scriptName=%~n0"

REM Initialize counters
set /a totalFiles=0
set /a renamedFiles=0

REM First pass: count all applicable files
for /R "%directory%" %%f in (*.*) do (
    REM Get the file extension without the dot
    set "extension=%%~xf"
    set "extension=!extension:~1!"

    REM Get the file name without the extension
    set "filename=%%~nf"

    REM Check if the file is the script itself or if the file extension is in the exclude list
    set "exclude=no"
    if /I "!filename!"=="%scriptName%" set "exclude=yes"
    for %%e in (%excludeExtensions%) do (
        if /I "!extension!"=="%%e" set "exclude=yes"
    )

    REM If the file extension is not in the exclude list and it is not the script, increment the totalFiles counter
    if "!exclude!"=="no" (
        set /a totalFiles+=1
    )
)

REM Second pass: rename files and update counters
for /R "%directory%" %%f in (*.*) do (
    REM Get the file extension without the dot
    set "extension=%%~xf"
    set "extension=!extension:~1!"

    REM Get the file name without the extension
    set "filename=%%~nf"

    REM Check if the file is the script itself or if the file extension is in the exclude list
    set "exclude=no"
    if /I "!filename!"=="%scriptName%" set "exclude=yes"
    for %%e in (%excludeExtensions%) do (
        if /I "!extension!"=="%%e" set "exclude=yes"
    )

    REM If the file extension is not in the exclude list and it is not the script, rename the file
    if "!exclude!"=="no" (
        REM Rename the file to include the original extension in the name and change to .txt
        ren "%%f" "!filename! !extension!.txt"
        set /a renamedFiles+=1
        set /a remainingFiles=totalFiles-renamedFiles
        echo Renamed: !renamedFiles!, Remaining: !remainingFiles!
    )
)

echo All applicable files have been renamed to include their original extension in the name and changed to .txt
pause
