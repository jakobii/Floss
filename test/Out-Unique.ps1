#unit

import-module "$PSScriptRoot\..\Inquiry.src.psm1"

Out-Unique @('A','a') | Out-Hash | Assert-String -Expect '0CC175B9C0F1B6A831C399E269772661' -Tag 'case insensitive'
