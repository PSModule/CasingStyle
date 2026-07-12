# CasingStyle

CasingStyle is a PowerShell module for detecting, converting, and splitting text casing styles. It is handy for text transformations,
standardizing variable names, and keeping formatting consistent across scripts.

## Installation

Install the module from the PowerShell Gallery:

```powershell
Install-PSResource -Name CasingStyle
Import-Module -Name CasingStyle
```

## Usage

### Example: Convert a string to a different casing style

```powershell
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'
# Output: this_is_camel_case

'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE'
# Output: THIS_IS_CAMEL_CASE

'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case'
# Output: this-is-camel-case
```

### Example: Detect the casing style of a string

```powershell
'testTestTest' | Get-CasingStyle
# Output: camelCase

'TestTestTest' | Get-CasingStyle
# Output: PascalCase
```

### Example: Split a string based on casing style

```powershell
Split-CasingStyle -Text 'this-is-a-kebab-case-string' -By 'kebab-case'
# Output:
# this
# is
# a
# kebab
# case
# string
```

## Documentation

Documentation is published at [psmodule.io/CasingStyle](https://psmodule.io/CasingStyle/).

Use PowerShell help and command discovery for module details:

```powershell
Get-Command -Module CasingStyle
Get-Help Get-CasingStyle -Examples
```
