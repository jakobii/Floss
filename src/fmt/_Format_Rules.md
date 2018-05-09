





# Formatters 

## Description
The **InputObject** of the **Format-*Noun*** Functions will be transformed and sanatized and then returned as a valid *string* representation appropriate for the intended datatype. Powershells ducktyping allows for easy convertions to a more specific datatype afterwards.

**Examples**
```powershell
[char]$result = Format-char "    F   "
# returns "F"

[Double]$result = Format-Percent "89%"
# returns ".89"

Format-ProperName "O'bRiAn"
Format-ProperName "mcdonald"
Format-ProperName "JaCoB OcHoA"
# returns "O'Brian" & "McDonald" & "Jacob Ochoa"

Format-Suffix "john, jr."
Format-Suffix "JOHN SR"
Format-Suffix "John iv"
# returns 'Jr' & 'Sr' & 'IV' 

Format-PhoneNumber '1231234'
Format-PhoneNumber '1231231234'
Format-PhoneNumber '1231231231234'
# returns '123-1234' & '(123) 123-1234' & '+123 (123) 123-1234'
```

Speed is important but it is not the end goal. The **Format-*Noun*** functions primary goal is to deliver rich & robust formatting. This often involves using Regular Expressions under the hood to travers complex patterns. All formatters should be able handle complex edge cases. 


## Rules
- To keep things uniform use the ***InputObject*** as functions main input parameter.
- Each formatter gets a test file. The file can use the **assert-*noun*** utils to check if the output of the function meets expectations. 
- return $Null if the resulting value evaluates to falsy. *Pop-Falsy* is used for this.
- Only accept a single value and return a single value. Other higher order functions can be built to handle delegating array members and the like.
- Formatters should support piping to the ***InputObject*** parameter.