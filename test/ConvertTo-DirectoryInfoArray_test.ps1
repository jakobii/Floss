Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\inquiry.psm1"



ConvertTo-DirectoryInfoArray -Path $PSScriptRoot
