#unit

import-module "$PSScriptRoot\..\inquiry.psm1"

Format-EmailAddress 'Blah blah blah o-m-g_omg@omg.com rar!' | assert-string -expect 'o-m-g_omg@omg.com' -tag 'email in the middle of sentance'

Format-EmailAddress 'Blah blah blah omg.123.omg@omg.rar.com rar?' | assert-string -expect 'omg.123.omg@omg.rar.com' -tag 'email in the middle of sentance with sub domain'

Format-EmailAddress 'OMG@OmG.CoM' | assert-string -expect 'omg@omg.com' -tag 'make lowercase'

