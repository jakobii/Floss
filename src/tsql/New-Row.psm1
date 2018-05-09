
# Import all src Module
$items = Get-ChildItem "$PSScriptRoot\..\fmt" -Recurse
foreach ($item in $items) {
    if ($item.Extension -eq '.psm1') {
        import-module $item.FullName
    }
}





Function Format-TQSL ($Type, $Value) {
    
    Switch ($Type) {
        'datetime2' {
            $Formated_Value = Format-DateTime2 $Value
            Break
        }

        'datetime' {
            $Formated_Value = Format-DateTime $Value
            Break
        }
    
        'date' {
            $Formated_Value = Format-Date $Value
            Break
        }
    
        'bit' {
            #$Formated_Value = Format-Func $Value
            Break
        }

        default {
            $Formated_Value = "$Value"
        }
    }
    return Protect-Sql -InputObject $Formated_Value
}





Function  Switch-Expression($Type, $Value) {
    
    Switch ($Type) {

        'datetime2' {
            $Sql_Expression = "CAST(NULLIF(RTRIM(LTRIM('$Value')),'') AS datetime2)"
            Break
        }

        'datetime' {
            $Sql_Expression = "CAST(NULLIF(RTRIM(LTRIM('$Value')),'') AS datetime)"
            Break
        }
        
        'date' {
            $Sql_Expression = "CAST(NULLIF(RTRIM(LTRIM('$Value')),'') AS date)"
            Break
        }
        
        'bit' {
            $Sql_Expression = "CAST(NULLIF(RTRIM(LTRIM('$Value')),'') AS bit)"
            Break
        }

        default {
            $Sql_Expression = "'$Value'"
        }
    }
    return $Sql_Expression
}









class tsqlrow {

    [string]$Column
    [string]$Expression
    $Original_Value
    $Formated_Value

    SqlRow($Col, $Expr) {

        $this.Format_Column($Col)
        $this.Add_Expression($Expr)
    }
    [void]Format_Column($val) {
        $this.Column = "[$val]"
    }

}





# deliverable Functions
Function New-Row {
    Param(
        [string]
        $Column,

        [object]
        $Value,

        [string]
        $Type
    )
    
    $TSQL_ROW = [tsqlrow]::new()
    $TSQL_ROW.Format_Column($Column)
    $TSQL_ROW.Original_Value = $Value
    $TSQL_ROW.Formated_Value = Format-TQSL -Type $Type -Value $TSQL_ROW.Original_Value
    $TSQL_ROW.Expression = Switch-Expression -Type $Type -Value $TSQL_ROW.Formated_Value

    return $TSQL_ROW
}
