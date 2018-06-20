#beta

FUNCTION Write-Type ($Value, $Tag){
    $typ = $Value.gettype()
    write-host  "Value : $Value" -f y
    write-host  "Name  : $($typ.Name)" -f y
    write-host  "Base  : $($typ.BaseType.Name)" -f y
    write-host  "Tag   : $Tag" -f y
}




