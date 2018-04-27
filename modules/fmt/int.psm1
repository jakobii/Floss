



function Format-Int($value){

    [string]$int = ''
    foreach($char in $value.ToCharArray()){
        [string]$str = $char
        if($str -match '^\d$'){
            [string]$int += $str
        }
    }

    if($int){
        return $int
    }
}












