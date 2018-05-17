

function format-ProperName {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline)]
        $InputObject
    )
    if (Test-Falsy $InputObject) { return $null }

    $eng = [System.Globalization.CultureInfo]::new('en-US')
        
    $Name = $eng.TextInfo.ToTitleCase($InputObject.tolower().trim())
    switch -Regex ($Name) {
        
        # Scrub !@#$%^&*()[ ]
        "[^a-zA-Z,. '-]+" {
            $regx = [regex]::new("[^a-zA-Z,. '-]+")
            $Name = $regx.Replace($Name, '')
        }

        # Remove Extra Middle whitespace
        "\b[\s]+\b" {
            $regx = [regex]::new("\b[\s]+\b")
            $Name = $regx.Replace($Name, ' ')
        }

        # [important!] Remove Suffix I-VII
        "\b([,. ]?[,. ])\b[IiVv]{1,3}$" {
            $regx = [regex]::new("\b([,. ]?[,. ])\b[IiVv]{1,3}$")
            $Name = $regx.Replace($Name, '')
            $name = $eng.TextInfo.ToTitleCase($Name.tolower())
        }

        # [important!] Remove Suffix John Jr, Martin Sr
        ".*\b[,.]?([ ]|[,\.])\b[JjSs][Rr]\b[,\.]?" {
            $regx = [regex]::new("\b[,\.]?([ ]|[,\.])\b[JjSs][Rr]\b[,\.]?")
            $Name = $regx.Replace($Name, '')
            $name = $eng.TextInfo.ToTitleCase($Name.tolower())
        }

        # O'Brian
        "^[Oo][\'][a-zA-Z-]+" {
            $regx = [regex]::new("^[Oo]\b[\']\b")
            $Name = $regx.Replace($Name, '')
            $Name = $eng.TextInfo.ToTitleCase($Name.tolower().trim())
            $Name = "O'" + $Name
        }

        # McDonald
        "^[Mm][Cc]\w+" {
            $regx = [regex]::new("^[Mm][Cc]")
            $Name = $regx.Replace($Name, '')
            $Name = $eng.TextInfo.ToTitleCase($Name.tolower().trim())
            $Name = "Mc" + $Name
        }

        # escape single quotes
        "'" {
            $regx = [regex]::new("'")
            $Name = $regx.Replace($Name, "''")
            Break
        }
    }
    
    return Pop-Falsy $Name
}














