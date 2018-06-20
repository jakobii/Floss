import-module "$PSScriptRoot\..\src\util\Compress-Modules.psm1"

$Compress_Params = @{
    Sources     = @("$PSScriptRoot\src")
    destination = "$PSScriptRoot\inquiry.min.psm1"
    version     = '1.0.0'
    Name        = 'Inquiry'
}

Compress-Modules @Compress_Params



