Import-Module "$PSScriptRoot\..\modules\tsql\New-Row.psm1"

# Dates
new-row -Column 'long DateTime' -Value $(Get-Date) -Type 'datetime2'
new-row -Column 'small DateTime' -Value $(Get-Date) -Type 'datetime'
new-row -Column 'Simple Date' -Value $(Get-Date) -Type 'date'















