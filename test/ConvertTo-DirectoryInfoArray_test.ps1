Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"



ConvertTo-DirectoryInfoArray -Path $PSScriptRoot
