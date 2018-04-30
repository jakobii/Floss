


Import-Module "$PSScriptRoot\..\tsql\invoke-tsql"

class log {
    $Svc
    $Func
    $type
    $cmd
    $comm
    $group
    $member
    $tag
    $id
    $start
    $end
}

function New-log {
    Param(

        $Svc,
        $Func,
        $type,
        $cmd,
        $comm,
        $group,
        $member,
        $tag,
        $id,
        $start,
        $end,

        [switch]
        $OutHost,

        [hashtable]
        $DBConn
    )

    if (!$Func) {[string]$Func = $(Get-PSCallStack)[1].FunctionName}
    if (!$CMD) {[string]$CMD = $(Get-PSCallStack)[1].Command}




    [string]$HostLog = "Svc    : $Service`n"
    [string]$HostLog += "func   : $Function`n"
    [string]$HostLog += "type   : $type`n"
    [string]$HostLog += "cmd    : $Command`n"
    [string]$HostLog += "comm   : $Comment`n"
    [string]$HostLog += "group  : $Group`n"
    [string]$HostLog += "member : $Member`n"
    [string]$HostLog += "tag    : $tag`n"
    [string]$HostLog += "id     : $id`n"
    [string]$HostLog += "start  : $start`n"
    [string]$HostLog += "end    : $end`n"
    




    Write-Host $HostLog  -f Yellow

    if ($OutHost) {

        switch ($type) {
            'start' {  
                Write-Host $HostLog  -f black -b DarkCyan
            }
            'end' {  
                Write-Host $HostLog  -f black -b DarkGray
            }
            'success' {  
                Write-Host $HostLog  -f green
            }
            'fail' {  
                Write-Host $HostLog  -f red
            }
            'note' {  
                Write-Host $HostLog 
            }
            'time' {  
                Write-Host $HostLog  -f Magenta
            }
            Default { Write-Host $Message}
        }

    }

    if ($DB) {

        

        $INSERT = "

        /* Check if Schema Exists */
        IF NOT EXISTS ( SELECT  * FROM sys.schemas WHERE name = N'log' ) 
        BEGIN 
        	EXEC('CREATE SCHEMA [log] AUTHORIZATION [dbo]');
        END
        GO

        /* Check if Table Exists */
        IF NOT EXISTS (
        	SELECT t.name as tb, 
        			s.name as sch
        	FROM sys.tables as t 

        	left join sys.schemas as s
        			on t.schema_id = s.schema_id
        	where 
        		s.name = 'log'
        		and t.name = 'ps'
        ) 
        BEGIN 
        	Create Table [log].[ps] (	
        		[Svc]    varchar(max),
        		[Func]   varchar(max),
        		[type]   varchar(max),
        		[cmd]    varchar(max),
        		[comm]   varchar(max),
        		[group]  varchar(max),
        		[member] varchar(max),
        		[tag]    varchar(max),
        		[id]     varchar(max),
        		[start]  datetime2,
        		[end]	 datetime2,

        		/*system fields*/
        		[recId] uniqueidentifier default newid(),
        		[recDt] datetime2 default getdate()

        	);
        END
        GO

        /* Insert Log */
        INSERT INTO [log].[ps]
        (
             [Svc]
            ,[Func]
            ,[type]
            ,[cmd]
            ,[comm]
            ,[group]
            ,[member]
            ,[tag]
            ,[id]
            ,[start]
            ,[end]
        )
        VALUES
        (
            '$Svc',
            '$Func',
            '$type',
            '$cmd',
            '$comm',
            '$group',
            '$member',
            '$tag',
            '$id',
            '$start',
            '$end'
        )
        GO
        "

        invoke-tsql @DBConn -Query $INSERT 





        # write log to table
        
    }
}




