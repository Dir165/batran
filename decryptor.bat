@echo off
setlocal

:: Path to the Decryptor.exe compiled in the previous example
set decryptor=C:\path\to\Decryptor.exe

:: Define the decryption key
set decryptionKey=mrdirweb33lizscriptkiddle

:: Loop through all drives and decrypt files
for /d %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    for /f "delims=" %%f in ('dir /a-d /s /b "%%d:\*.enc" 2^>nul') do (
        set "file=%%d:\%%f"
        set "tempFile=%%~dpnf_dec"

        :: Prepare the arguments for the decryptor with the key
        set "arguments=%decryptionKey% %%f"

        :: Decrypt the file using the compiled Decryptor
        call !decryptor! %arguments% >nul 2>&1
        if %errorlevel% equ 0 (
            :: Delete the encrypted file and move the decrypted file back to its original name
            del "!file!"
            move /y "!tempFile!" "!file!"
        )
    )
)

:: Clean up temporary files
for /f "tokens=*" %%f in ('dir /b /s /a:-h !temp%tempnum%!\*') do del "%%f"
rd /s /q !temp%tempnum%\

echo Your files have been decrypted.
pause
exit
