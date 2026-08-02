filter ConvertTo-CasingStyle {
    <#
        .SYNOPSIS
        Convert a string to a different casing style

        .DESCRIPTION
        This function converts a string to a different casing style.

        .EXAMPLE
        'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'

        Convert the string 'thisIsCamelCase' to 'this_is_camel_case'

        .EXAMPLE
        'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE'

        Convert the string 'thisIsCamelCase' to 'THIS_IS_CAMEL_CASE'

        .EXAMPLE
        'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case'

        Convert the string 'thisIsCamelCase' to 'this-is-camel-case'

        .INPUTS
        System.String

        The text to convert, piped in.

        .OUTPUTS
        System.String

        The text rewritten in the requested casing style.

        .LINK
        https://psmodule.io/CasingStyle/Functions/ConvertTo-CasingStyle/
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        # The string to convert
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $Text,

        # The casing style to convert the string to
        [Parameter(Mandatory)]
        [ValidateSet(
            'lowercase',
            'UPPERCASE',
            'Title Case',
            'Sentencecase',
            'PascalCase',
            'camelCase',
            'kebab-case',
            'UPPER-KEBAB-CASE',
            'snake_case',
            'UPPER_SNAKE_CASE'
        )]
        [string] $To
    )

    $currentStyle = Get-CasingStyle -Text $Text

    $words = Split-CasingStyle -Text $Text -By $currentStyle

    # Convert the words into the target style
    switch ($To) {
        'lowercase' { ($words -join '').ToLower() }
        'UPPERCASE' { ($words -join '').ToUpper() }
        'Title Case' { ($words | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower() }) -join ' ' }
        'Sentencecase' { $words -join '' | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower() } }
        'kebab-case' { ($words -join '-').ToLower() }
        'snake_case' { ($words -join '_').ToLower() }
        'PascalCase' { ($words | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower() }) -join '' }
        'camelCase' {
            $words[0].ToLower() + (($words | Select-Object -Skip 1 | ForEach-Object { $_.Substring(0, 1).ToUpper() + $_.Substring(1) }) -join '')
        }
        'UPPER_SNAKE_CASE' { ($words -join '_').ToUpper() }
        'UPPER-KEBAB-CASE' { ($words -join '-').ToUpper() }
    }
}
