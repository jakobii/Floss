Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"


New-Path -Path "C:\temp\rar\blah.csv" -Verbosely -ExcludeFile