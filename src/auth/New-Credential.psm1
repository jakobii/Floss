

function New-Credential {
    param(
        [parameter(Mandatory = $true)]
        [alias("u")]
        [string]
        $Username,

        [parameter(Mandatory = $true)]
        [alias("p")]
        [string]  
        $Password
    )
    $SecureString = ConvertTo-SecureString $Password -AsPlainText -Force
    return [System.Management.Automation.PSCredential]::new($Username, $SecureString)
}



