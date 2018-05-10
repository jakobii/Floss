



FUNCTION Get-Resource {
    Param(

        [parameter(ParameterSetName = "ID", Mandatory = $true)]
        [string]
        $ID,

        [parameter(ParameterSetName = "Group", Mandatory = $true)]
        [string]
        $Group,

        [System.io.fileinfo]
        $Path


    )


    # RESOLVE PATH
    if ($Path) {
        $JSON_PATH = $Path
    }
    elseif (!$Path) {
        
        $ParentFunction = Get-Function -CallStack 2
        $ParentFunctionDirectory = $($ParentFunction.Directory)
        #Check the current directory and the move out
        if (Test-Path  "$ParentFunctionDirectory\resources.json") {
            $JSON_PATH = "$ParentFunctionDirectory\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\conf\resources.json"
        }
        
        elseif (Test-Path  "$ParentFunctionDirectory\..\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\conf\resources.json"
        }

        elseif (Test-Path  "$ParentFunctionDirectory\..\..\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\..\resources.json"
        }
        elseif (Test-Path  "$ParentFunctionDirectory\..\..\conf\resources.json"  ) {
            $JSON_PATH = "$ParentFunctionDirectory\..\..\conf\resources.json"
        }
        # last ditch effort. check a child directory.
        else {

            try {
                $ChildItem = Get-ChildItem -Name 'resources.json' -Recurse -Depth 1 -ErrorAction 'stop'
            }
            catch {}

            if ($ChildItem) {
                $JSON_PATH = $ChildItem.FullName
            }
            else {
                Write-Fail "Could Not Find resources.json"
                Return
            }
        }
    }

   

    # Import Json Content
    try {
        # get dependancies
        $content_params = @{
            Raw         = $true
            ErrorAction = 'stop'
            Path        = $JSON_PATH  # [fix] hard coded paths suck
        }
        $Content = Get-Content @content_params
    }
    catch {
        Write-Fail "$JSON_PATH Could Not be imported. $psitem"
        Return
    }


    # Convert Json
    try {
        $Resources = ConvertFrom-Json -InputObject $Content -ErrorAction 'stop'
    }
    catch {
        Write-Fail "Could not convert Json to psobject. $JSON_PATH , $psitem"
        Return
    }


    # Select Object

    if ($PSCmdlet.ParameterSetName -eq 'ID') {
        foreach ($Resource in $Resources) {
            if ($Resource.ID -eq $ID) {
                $OutputObject = $Resource
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        [array]$OutputObject = @()
        foreach ($Resource in $Resources) {
            if ($Resource.Group -eq $Group) {
                [array]$OutputObject += $Resource
            }
        }
    }

    Return Pop-Falsy $OutputObject
}
