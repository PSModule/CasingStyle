# CasingStyle

The `CasingStyle` PowerShell module provides functions for detecting, converting, and splitting different casing styles in strings. This can be
useful for text transformations, standardizing variable names, and ensuring consistent formatting in scripts.

## Prerequisites

This module does not require additional dependencies, but it integrates well with the [PSModule framework](https://github.com/PSModule) for building,
testing, and publishing PowerShell modules.

## Installation

To install the module from the PowerShell Gallery, you can use the following command:

```powershell
Install-PSResource -Name CasingStyle
Import-Module -Name CasingStyle
```

## Usage

The following examples demonstrate common use cases for the module, showing how it can be applied to detect, convert, and manipulate different casing
styles in strings.

### Example 1: Convert a string to a different casing style

```powershell
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'
# Output: this_is_camel_case
```

```powershell
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE'
# Output: THIS_IS_CAMEL_CASE
```

```powershell
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case'
# Output: this-is-camel-case
```

### Example 2: Detect the casing style of a string

```powershell
'testTestTest' | Get-CasingStyle
# Output: camelCase
```

```powershell
'TestTestTest' | Get-CasingStyle
# Output: PascalCase
```

### Example 3: Split a string based on casing style

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

```powershell
Split-CasingStyle -Text 'ThisIsAPascalCaseString' -By 'PascalCase'
# Output:
# This
# Is
# A
# Pascal
# Case
# String
```

### Find more examples

To find more examples of how to use the module, please refer to the [examples](examples) folder.

Alternatively, you can use the following PowerShell commands:

```powershell
Get-Command -Module 'CasingStyle'
```

To find examples of each of the commands, you can use:

```powershell
Get-Help ConvertTo-CasingStyle -Examples
```

## Documentation

For further documentation, please visit the official documentation pages for each function:

- [ConvertTo-CasingStyle](https://psmodule.io/CasingStyle/Functions/ConvertTo-CasingStyle/)
- [Get-CasingStyle](https://psmodule.io/CasingStyle/Functions/Get-CasingStyle/)
- [Split-CasingStyle](https://psmodule.io/CasingStyle/Functions/Split-CasingStyle/)

## Contributing

Regardless of your experience level, your contributions are valuable! Whether you're a beginner or an expert, you can help improve this project by
sharing feedback, reporting issues, or contributing code.

### For Users

If you encounter unexpected behavior, errors, or missing functionality, you can help by submitting bug reports and feature requests.
Please see the issues tab on this project and submit a new issue that describes your experience.

### For Developers

If you write code, we'd love to have your contributions! Please read the [Contribution guidelines](CONTRIBUTING.md) for more information.
You can either help by picking up an existing issue or submit a new one if you have an idea for a new feature or improvement.
