

Import-Module $PSScriptRoot\..\discord.psm1

$discord = Get-Resource -ID 'discord'

Send-DiscordMessage -Message 'PS BOT Test' -URL $discord.uri #-OnSuccess -OnError -Verbosely




