Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
import-module "$PSScriptRoot\..\Inquiry.src.psm1"


$basic = {
 
    import-module .\..\PSDTK.psm1

}





Invoke-AsAdmin -Command $basic 


