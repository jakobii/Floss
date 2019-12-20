# Floss

A Powershell Module for Cleaning Data.

## Names


Notice that the `Format-Name` cmdlet correctly: 
- capitalizes name parts correctly
- removes suffix
- removes tiles
- removes extra white space
- removes non-aphla characters sanely


```powershell
Format-Name " 90123 Dr Mrs. MaRrY-JANE     o'brian   mCdonALD III jr. "
```

Outputs:

```
Marry-Jane O'Brian McDonald
```

## Phone Numbers

Formating phonenumbers can be a pain. not anymore.

```powershell
Format-PhoneNumber 1231231231234
```

Outputs:

```
+123 (123) 123-1234
```

## Numbers

Sometimes you need to just exrtact numbers from data.

```powershell
Get-Numbers ' abc123 '
```
Outputs

```
123
```

## Uppercase and Lowercase

These are handy when formating in a pipline.

```powershell
@('A','B','C') | Format-LowerCase
```

Outputs:

```
a
b
c
```

```powershell
@('a','b','c') | Format-UpperCase
```

Outputs:

```
A
B
C
```
