#unit


import-module "$PSScriptRoot\..\inquiry.psm1"


ConvertFrom-Percentage 'some bad data 99.9999% some more bad data.' | Assert-String -Expect '0.999999' -Tag 'very close to number 1 or 100%'


