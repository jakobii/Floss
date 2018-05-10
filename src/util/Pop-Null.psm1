


Function Pop-Null {
    Param(
        [switch]
        $DBNull
    )

    if($DBNull){
        return New-DBNull
    }
    else{
        return $null
    }
}
