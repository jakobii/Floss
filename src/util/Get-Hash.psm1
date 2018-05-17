
function Get-Hash {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject,
        
        [ValidateSet("byte", "hex", "string")]
        [string]
        $OutputAs = 'hex',

        [ValidateSet("MD5", "SHA256", "SHA512")]
        [string]
        $Algorithm = 'MD5'
    )


    switch ($Algorithm ) {
        'MD5' {$Cryptography = new-object System.Security.Cryptography.MD5CryptoServiceProvider} 
        'SHA256' {$Cryptography = new-object System.Security.Cryptography.SHA256Managed} 
        'SHA512' {$Cryptography = new-object System.Security.Cryptography.SHA512Managed} 
    }
    
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($InputObject)
    $ByteArray = $Cryptography.ComputeHash($Bytes)
    


    switch ($OutputAs) {
        'byte' {
            $OutputObject = $ByteArray 
        }
        'hex' {
            [string]$OutputObject = [String]::Join("", ($ByteArray | ForEach-Object { "{0:X2}" -f $_}))
        }
        'string' {
            foreach ($byte in $ByteArray) {
                [string]$OutputObject += $byte.ToString()
            }
        }
    }
    return $OutputObject
}


