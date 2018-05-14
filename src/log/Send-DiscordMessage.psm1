


FUNCTION Send-DiscordMessage {
    param(
        $Message,
        $URL,
        
        [scriptblock]
        $OnSuccess,

        [scriptblock]
        $OnError,
        
        [switch]
        $Verbosely
    )

    if ($url) {
        $restParam = @{
            Method      = 'POST'
            Uri         = $URL
            Body        = @{content = $Message}
            ErrorAction = 'stop'
        }
        try {
            Invoke-RestMethod @restParam
            if($OnSuccess){$OnSuccess.Invoke($restParam)}
        }
        catch {
            if($OnSuccess){$OnSuccess.Invoke($restParam,$PSItem)}
            if($Verbosely){Write-Host $PSItem -f red }
        }
    }
    

}     
        

