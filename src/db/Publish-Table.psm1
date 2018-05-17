





Function Publish-Table {
    param(

        [parameter(Mandatory = $true)]
        [string]
        $Server, 
        
        [parameter(Mandatory = $true)]
        [string]
        $Database, 
        
        [string]
        $Schema = 'dbo',
        
        [parameter(Mandatory = $true)]
        [string]
        $Table,
        
        [parameter(Mandatory = $true)]
        $InputObject,
         

        [switch]
        $Verbosely,

        [string]
        $Username,

        [string]
        $Password
    )

    # Production table Safty net.
    if ($Schema -eq 'pro') {
        write-fail -Verbosely $true -m 'You can not publish to production table. Please choose a different Schema.' 
        return
    }

    $Params = @{}
    if ($Server) {$Params.Server = $Server }
    if ($Database) {$Params.Database = $Database}
    if ($Schema) {$Params.Schema = $Schema}
    if ($Table) {$Params.Table = $Table}
    if ($Verbosely) {$Params.Verbosely = $Verbosely}
    if ($Username) {$Params.Username = $Username}
    if ($Password) {$Params.Password = $Password}
    Remove-Table @Params | Out-Null


    if ($InputObject) {$Params.InputObject = $InputObject}
    $Params.force = $true
    Write-table @Params | Out-Null

}



























