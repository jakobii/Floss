# Inquiry Powershell Module
A remarkable powershell module for manipulating data that is writen in a functional manner and is made with Love ❤️

## Get Started
```powershell
git clone https://github.com/jakobii/Inquiry.git
import-module .\inquiry\inquiry.psm1
```

#### Dependancies
 - [SqlServer](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module) *for funciton that interact with sql server*




## Formaters

The **Format-*Noun*** functions primary goal is to deliver rich & robust formatting. This often involves using Regular Expressions under the hood to travers complex patterns. All formatters should be able handle complex edge cases. 


#### *Format-Percent*
```powershell

Format-Percent "89%"
# returns .89
```

#### *Format-ProperName*
```powershell
Format-ProperName "O'bRiAn"
# returns "O'Brian"

Format-ProperName "mcdonald"
# returns "McDonald" 

Format-ProperName "JaCoB OcHoA"
# "Jacob Ochoa"
```
#### *Format-Suffix*
```powershell
Format-Suffix "jOhN, jR."
# returns 'Jr'

Format-Suffix "JOHN SR"
# returns 'Sr'

Format-Suffix "John iv"
# returns 'IV' 
```
#### *Format-PhoneNumber*
```powershell
Format-PhoneNumber '1231234'
# returns '123-1234'

Format-PhoneNumber '1231231234'
# returns '(123) 123-1234' 

Format-PhoneNumber '1231231231234'
# returns '+123 (123) 123-1234'
```
#### *Format-Number*
```powershell
Format-Number '!1@2#3$4%5'
# returns 12345 
```

#### *Format-char*
```powershell
Format-char "    F   some_bad_data"
# returns "F"

Format-char "    M   some_bad_data"
# returns "M"
```

#### *Format-EmailAddress*
```powershell
Format-EmailAddress 'bad data    SoMe.cOmPlEx_name@sub.domain.com    more bad data?' 
# returns some.complex_name@sub.domain.com
```

The **InputObject** of the **Format-*Noun*** Functions will be transformed and sanatized and then returned as a valid *string* representation appropriate for the intended datatype. Powershells allows for easy convertions to a more specific datatype afterwards.



## Database
powershell has gotten a bit better at interacting with Sql Server but wouldn't it be awesome if you could just define a sql server objects with just hashtables and arrays?

#### *ConvertTo-DataRows*
```powershell
$Parameters = @{

    TableName = 'employees'
    
    # column names & datatypes with the [ordered] keyword.
    Columns   =  [ordered] @{id = 'int'; fn = 'string' ; hd = 'datetime'}
    
    # A simple array of hashtables
    Rows      = @(
        @{ id = 123 ; fn = 'rick'  ; hd = $(get-date)  }
        @{ id = 456 ; fn = 'steve' ; hd = '2014-07-08' }
        @{ id = 789 ; fn = 'beth'  ; hd = '2018-12-09' }
    )
}

ConvertTo-DataRows @Parameters
```
Outputs
```
id : 123
fn : rick
hd : 6/20/2018 2:06:05 PM

id : 456
fn : steve
hd : 7/8/2014 12:00:00 AM

id : 789
fn : beth
hd : 12/9/2018 12:00:00 AM
```

## Utilities


#### *Test-Falsy* 
Finds falsy values with some sanity. returns `$True` when a falsy value is found.
```powershell
# dbnull
Test-Falsy $([dbnull]::value)
# return $True

# arrays
Test-Falsy @($null, ' ', 0 ,$([dbnull]::value) )
# return $True

# hashtables
Test-Falsy @{num = 1; txt='some text'}
# return $False
```


#### *Out-Hash* 
Yay! you can hash things in powershell now...
```powershell

Out-Hash 'md5 this please'
# returns FBD885AEF70DDAD2073F35170C0CE64F

Out-Hash 'SHA512 this please' -Algorithm SHA512 -OutputAs byte
# returns 76 115 148 198 34 242 ...you get the idea
```


#### *Out-Unique* 
Arrays does not need to be sorted.
```powershell
Out-Unique @( 'b','a','b','a', 'A' )
# returns b, a, A
```
#### *Get-Type*
This really should be in the standard library!
```powershell
Get-Type 'a string'
Get-Type @('an','array')
```
Outputs
```
IsPublic IsSerial Name   BaseType
-------- -------- ----   --------
True     True     String System.Object

IsPublic IsSerial Name     BaseType
-------- -------- ----     --------
True     True     Object[] System.Array

```
#### *ConvertTo-Type*
This is super useful in piping senerios.
```powershell
'multipart/form-data=1345' | Format-Number | ConvertTo-Type double | Get-Type
```
Outputs
```
IsPublic IsSerial Name   BaseType
-------- -------- ----   --------
True     True     Double System.ValueType
```






