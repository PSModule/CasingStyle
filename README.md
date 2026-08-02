# CasingStyle

`CasingStyle` is a PowerShell module that detects, converts, and splits the casing style of text. Use it to normalize variable names, translate
identifiers between conventions, and keep generated output consistently formatted.

It recognizes `lowercase`, `UPPERCASE`, `Sentencecase`, `Title Case`, `PascalCase`, `camelCase`, `kebab-case`, `UPPER-KEBAB-CASE`, `snake_case`, and
`UPPER_SNAKE_CASE`, and needs nothing beyond PowerShell itself.

## Installation

Install the module from the PowerShell Gallery:

```powershell
Install-PSResource -Name CasingStyle
Import-Module -Name CasingStyle
```

## Capabilities

Detect the casing style of a string:

```powershell
'testTestTest' | Get-CasingStyle
# camelCase
```

Convert a string to another casing style, whichever style it starts in:

```powershell
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'
# this_is_camel_case

'this-is-kebab-case' | ConvertTo-CasingStyle -To 'PascalCase'
# ThisIsKebabCase
```

Split a string into the words its casing encodes, chaining styles when the text mixes several:

```powershell
'this_is_a-PascalString' | Split-CasingStyle -By 'snake_case', 'kebab-case', 'PascalCase'
# this
# is
# a
# Pascal
# String
```

More end-to-end scenarios live in the [examples](examples) folder.

## Documentation

Documentation is published at [psmodule.io/CasingStyle](https://psmodule.io/CasingStyle/).

Use PowerShell help and command discovery for module details:

```powershell
Get-Command -Module CasingStyle
Get-Help -Name ConvertTo-CasingStyle -Examples
```
