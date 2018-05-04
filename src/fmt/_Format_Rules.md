





# TSQL DataTypes Formating 

## Description
Although both product are buld by microsoft, powershell and tsql, they dont always play well together. This is in part due to the teams having very different goal, but also tsql is a much older language. in any case there is a need to bridge the gap, to ensure that data can be reliably converted into something sql server can understand and use. thus we have formatter functions. these are writen with the functional programing philosophy and are easy to test and debug.

## Rules
- All formaters should return SQL safe string Representation of the data
- formaters should return $null if blank to ensure no empty spaces are added to strings
- formater should also handle escaping, because escape rules may differ depending on the type and expectation of the formatter
- All formatters should take a single value and return a single value. Other higher order functions can be built to handle delegating array members and the like.
- Unless completely necessary, you should use the **-value** parameter name as the functions input paramter.
- Each formatter gets a test file. the file can use the assert-string util to check if the output of the function meets expectations.