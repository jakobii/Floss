


function ConvertTo-Type {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        $InputObject,

        [parameter(Mandatory = $true)]
        [ValidateSet("int", "int32", "int64", "string", "char", "long", "double", "datetime", "bool", "boolean", "guid")]
        [string]
        $Type = 'string',

        [switch]
        $DBNull
    )
    if (Test-Falsy $InputObject) { return Pop-Null -DBNull:$DBNull }
    
    
    try {
        switch ($Type) {
            {($_ -eq "int") -or ($_ -eq "int32")} {
                try {
                    $Outputobject = [Convert]::ToInt32($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            "int64" {
                try {
                    $Outputobject = [Convert]::ToInt64($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            "string" {
                $Outputobject = [Convert]::ToString($InputObject)
                RETURN $Outputobject
            }
            "char" {
                $Outputobject = [Convert]::ToChar($InputObject)
                RETURN $Outputobject
            }
            "long" {
                [long]$Outputobject = [Convert]::ToInt64($InputObject)
                RETURN $Outputobject
            }
            "double" {
                [double]$Outputobject = [Convert]::ToDouble($InputObject)
                RETURN $Outputobject
            }
            "datetime" {
                try {
                    $Outputobject = [Convert]::ToDateTime($InputObject)
                }
                catch {
                    $Outputobject = Pop-Null -DBNull:$DBNull
                }
                RETURN $Outputobject
            }
            {($_ -eq "bool") -or ($_ -eq "boolean")} {
                [boolean]$Outputobject = [Convert]::ToBoolean($InputObject)
                RETURN $Outputobject
            }
            "guid" {
                [guid]$Outputobject = $InputObject
                RETURN $Outputobject
            }
        }
    }
    catch {
        Write-Fail $PSItem
        return Pop-Null -DBNull:$DBNull
    }

}