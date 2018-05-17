



Function Get-Max ($InputObject) {
    foreach($item in $InputObject){
        if($item -gt $max){
            $max = $item
        }
    }
    return pop-falsy $max
}

