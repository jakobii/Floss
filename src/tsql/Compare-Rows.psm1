



function Compare-Rows ([tsqlrow]$old,[tsqlrow]$new) {
    # return true if the are different
    
    $different = $false
    foreach($key in $new.keys){
        if( $($new.$key) -ne  $($old.$key) ){
            $different = $true
        }
    }
    return $different
}











