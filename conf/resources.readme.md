# Resources
Some functions need configuration to work correctly. thus the need for a place to store Resouce Specific Information. the reources.json file is not intended to replace a database, but can be used to store basic domain specific information.

## Example
A good example for this would be to store information required to conenct to a database. You can add any JSON object in the reources.json *main array*, as long as it has a *ID Pair* in the root object.


```javascript
//main array
[ 

    //object 1
    { 
        //ID is required
        "ID":"MyDB",
        "Server": "Srv01",
        "Database": "AwesomeDb"
        "Columns":[
            { "Name":"id" , "Type": 'int' },
            { "Name":"fn" , "Type": 'string' },
            { "Name":"ln" , "Type": 'string' },
            { "Name":"hd" , "Type": 'datetime' }
        ]
    },

    //object 2
    {
        // ID is required
        "ID":"fs", 
        "Server": "Srv02",
        "File_Share": "C:\\some\\file\\path"
    }
]
```


**Please keep in mind that this is JSON. So pay mind to doubling up backslackes, and other gotchas. [json.org](https://www.json.org/)*

**You are Responsible for keeping the ID's Unique*

### Why JSON?
JSON is just a medium for serializing javacript objects. Powershell does not have a native serialization model and XML super sucks. Powershell can convert JSON Natively into proper powershell objects. JSON is an internet standard and is easy to read.



# Get-Resource
The function Get-Resource makes using the resources.json file easy. Once you have add a resource object you can forget the resouce is stored JSON, and just use it as a normal psobject.

## Example
```powershell
$DB = Get-Resouce -ID 'MyDB'

$DB.Server
$DB.Database
$DB.Columns[3]
```

If you dont store your resources.json in the **conf** directory. you can do this.

```powershell
$DB = Get-Resouce -ID 'MyDB' -Path "C:\path\to\resources.json"
```


