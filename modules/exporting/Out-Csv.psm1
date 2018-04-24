



FUNCTION Out-Csv {

    Param(

        [string]
        $Path,

        $Value,

        [switch]
        $Verbosely
    )

    
    Write-Host "`n`0Starting $($MyInvocation.MyCommand)`0" -f 'white' -b 'DarkBlue'

    try {
        $Value | Export-Csv -Path $Path -Force -NoTypeInformation -ErrorAction 'Stop'
        if ($Verbosely) { Write-Host "Success`t:`0True" -f 'green'}
        if ($Verbosely) {Write-Host "Csv`t:`0$Path" -f Green}
    }
    catch {
        if ($Verbosely) {Write-Host "`Error`t:`0$PSItem " -f Red}    
        if ($Verbosely) {Write-Host "Csv`t:`0$Path" -f Red}
    }

}










