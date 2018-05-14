# Resources
Some functions need configuration to work correctly. Thus the need for a place to store resouce specific information. The **reources.json** file is not intended to replace a database. Its primary goal is to allow for a seperation of concern between the domain specific conifiguration and the actual programing logic.

## Example
A good example for this would be to store basic information required to connect to a database. You can add any JSON object in the reources.json *main array*, as long as it has a **ID** attribute in the root object. The **Group** attribute is optional.


```javascript
//main array
[ 

    //resource object 1
    { 
        "ID":"MyDB", //required
        "Group":"NY-01", //optional
        "Server":"Srv01",
        "Database":"AwesomeCo",
        "Table":"Employees",
        "Columns": [
            { "Name":"id" , "Type":"int" },
            { "Name":"fn" , "Type":"string" },
            { "Name":"ln" , "Type":"string" },
            { "Name":"hd" , "Type":"datetime" }
        ]
    },

    //resource object 2
    {
        "ID":"fs", //required
        "Group":"NY-01",  //optional
        "Server":"Srv02",
        "File_Share":"C:\\some\\file\\path"
    }

    //..add as many resource objects as you would need..
]
```


**Please keep in mind that this is JSON. So pay mind to doubling up backslackes, and other gotchas. [json.org](https://www.json.org/)*

**You are Responsible for keeping the ID's Unique*

### Why JSON?
JSON is just a medium for serializing javacript objects. Powershell does not have a native serialization model and XML super sucks! Powershell can convert JSON Natively into proper powershell objects. JSON is an internet standard and is easy to read.


---

# Get-Resource

```info
Get-Resource -ID <string> [-Path <system.io.fileinfo>]
```

```info
Get-Resource -Group <string> [-Path <system.io.fileinfo>]
```

## Description
The function Get-Resource makes using the resources.json file easy. Once you have add a resource object to the resources.json file you can forget the resouce is stored as JSON, and just use it as a normal psobject.

The Get-Resource function is *intentionally simple*. Powershell arrays are not very performant. If performance is a concern, large configurations are better off store in a database. Get-Resource is just intened to give a script enough information to get going.

The resource file must be named **resources.json**.

## Example
The **ID** parameter returns a single resource Objects.
```powershell
$DB = Get-Resouce -ID 'MyDB'

$DB.Server
$DB.Database
$DB.Columns[3]
```
The **Group** parameter returns an array of resources. notice you can use wildcards.

```powershell
$Resources = Get-Resouce -Group 'NY-*'

$Resources[0].Server
$Resources[1].Server
```


Get-Resource will search for the resources.json file in the following order. *Current* being psscriptroot of the function that calls Get-Resouce. 
1) current / resources.json
2) current / conf / resources.json
3) parent / resources.json
4) parent / conf / resources.json
5) grandparent / resources.json
6) grandparent / conf / resources.json

You can override this search by providing a path.

```powershell
$FS = Get-Resouce -ID 'fs' -Path "C:\path\to\resources.json"
```



## Parameters

### Group
The Group parameter will cause Get-Resouce to return an array of resouce objects.


|Propery|Value|
|---|---|
|type|string|
|Wildcards|true|
|Pipline|false|
|Retrun|Array|


### ID
The ID parameter will always return a single resource object.

|Propery|Value|
|---|---|
|type|string|
|Wildcards|false|
|Pipline|false|
|Retrun|psobject|


### Path
The Path parameter is used to direct Get-Resource to look at a specific resources.json file and override its automatic search functions.

|Propery|Value|
|---|---|
|type|system.io.fileinfo|
|Wildcards|false|
|Pipline|false|
|Retrun|psobject|

---

# TODO

- Encyption of resources.json ??? 
    - allow decryption with a secure string or cert.
- Validate a resources.json with file a **Test** Parameter
    - check syntax
    - check for Dup IDs
    - count objects
    - sample query timespan
- Allow JSON content to be piped into a **InputObject** Parameter


