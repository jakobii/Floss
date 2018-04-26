
# DataTypes Formaters
- All formaters should return SQL safe string Representation of the data
- formaters should return $null if blank to ensure no empty spaces are added
- formater should also handle escaping, because escape rules may differ depending on the type
- All formatters should take a single value and return a single value.
- Unless completely necessary, you should use **-value** and the functions input paramter.
