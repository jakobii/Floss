


Function Show-Progress {
    Param(
        [double]    
        $Goal,

        [double]
        $Step,

        [string]
        $Tag,

        $ID = 50
    )

    $Progress_double = ($Step / $Goal) * 100
    Write-Progress -Activity $Tag -Status "Complete: $Progress_double%" -PercentComplete $Progress_double -Id $ID
}

