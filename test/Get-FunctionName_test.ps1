







import-module "$PSScriptRoot\..\psdtk.psm1"




Function foo-Bar () {
    write-host $(Get-FunctionName)
}

foo-Bar



