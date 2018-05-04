






Function New-InsertInto {
    Param(
        
        [string]
        $Schema = 'dbo',
        
        [string]
        $table,
        
        [array]
        $Rows
    )

    # Declare Elements 
    [string]$BEGIN_STATEMENT = "INSERT INTO [$($schema)].[$($table)] ( `n"
    [string]$MIDDLE_STATEMENT += "`n)`nVALUES (`n"
    [string]$ENDING_STATEMENT += "`n);`nGO"
    [string]$COLUMN_NAME_ARRAY = ''
    [string]$VALUE_FUNC_ARRAY = ''

    # Concat Elms as Strings
    [int]$COUNTER = 0
    Foreach ($SqlObj in $SqlElms) {
        if ($COUNTER -ne 0) {$COLUMN_NAME_ARRAY += ", `n"}
        if ($COUNTER -ne 0) {$VALUE_FUNC_ARRAY += ", `n"}
        $COLUMN_NAME_ARRAY += $SqlObj.Column
        $VALUE_FUNC_ARRAY += $SqlObj.Expression
        $COUNTER++
    }

    # Build Statement
    [string]$INSERT_STATEMENT += $BEGIN_STATEMENT
    [string]$INSERT_STATEMENT += $COLUMN_NAME_ARRAY
    [string]$INSERT_STATEMENT += $MIDDLE_STATEMENT
    [string]$INSERT_STATEMENT += $VALUE_FUNC_ARRAY
    [string]$INSERT_STATEMENT += $ENDING_STATEMENT

    return $INSERT_STATEMENT
}






