filter Split-CasingStyle {
    <#
        .SYNOPSIS
        Splits a string based on one or more casing styles.

        .DESCRIPTION
        This function takes a string and an array of casing styles (via the -By parameter)
        and splits the string into its component words. It does this iteratively,
        applying each split to every token produced by the previous one.

        .EXAMPLE
        Split-CasingStyle -Text 'this-is-a-kebab-case-string' -By kebab-case

        this
        is
        a
        kebab
        case
        string

        .EXAMPLE
        Split-CasingStyle -Text 'this_is_a_kebab_case_string' -By 'snake_case'

        this
        is
        a
        kebab
        case
        string

        .EXAMPLE
        Split-CasingStyle -Text 'ThisIsAPascalCaseString' -By 'PascalCase'

        This
        Is
        A
        Pascal
        Case
        String

        .EXAMPLE
        Split-CasingStyle -Text 'thisIsACamelCaseString' -By 'camelCase'

        this
        Is
        A
        Camel
        Case
        String

        .EXAMPLE
        Split-CasingStyle -Text 'this_is_a-CamelCaseString' -By kebab-case | Split-CasingStyle -By snake_case

        this_is_a
        camelcasestring

        .EXAMPLE
        'this_is_a-PascalString' | Split-CasingStyle -By 'snake_case','kebab-case','PascalCase'

        .OUTPUTS
        [string[]] - An array of strings, each representing a word in the original string

        .LINK
        https://psmodule.io/Casing/Functions/Split-CasingStyle/
    #>
    [CmdletBinding()]
    param(
        # The string to split
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string]$Text,

        # The casing style(s) to split the string by.
        [Parameter()]
        [ValidateSet(
            'lowercase',
            'UPPERCASE',
            'Sentencecase',
            'Title Case',
            'PascalCase',
            'camelCase',
            'kebab-case',
            'UPPER-KEBAB-CASE',
            'snake_case',
            'UPPER_SNAKE_CASE'
        )]
        [string[]]$By
    )

    process {
        Write-Verbose "Starting with string: [$Text]"
        # Start with the original text as the only token.
        $tokens = @($Text)

        # For each casing style in the -By list, split every token accordingly.
        foreach ($style in $By) {
            Write-Verbose "Splitting by casing style: $style"
            $newTokens = @()
            foreach ($token in $tokens) {
                switch ($style) {
                    'PascalCase' {
                        # Use regex to match sequences like 'Pascal' and 'String' in 'PascalString'
                        $matchedTokens = [regex]::Matches($token, '([A-Z][a-z]*)')
                        if ($matchedTokens.Count -gt 0) {
                            $newTokens += $matchedTokens | ForEach-Object { $_.Value }
                        } else {
                            $newTokens += $token
                        }
                        break
                    }
                    'camelCase' {
                        # Match leading lowercase or uppercase letter groups
                        $matchedTokens = [regex]::Matches($token, '(^[a-z]+|[A-Z][a-z]*)')
                        if ($matchedTokens.Count -gt 0) {
                            $newTokens += $matchedTokens | ForEach-Object { $_.Value }
                        } else {
                            $newTokens += $token
                        }
                        break
                    }
                    'kebab-case' {
                        $newTokens += $token -split '-'
                        break
                    }
                    'UPPER-KEBAB-CASE' {
                        $newTokens += $token -split '-'
                        break
                    }
                    'snake_case' {
                        $newTokens += $token -split '_'
                        break
                    }
                    'UPPER_SNAKE_CASE' {
                        $newTokens += $token -split '_'
                        break
                    }
                    default {
                        # For any other case styles, you might split on whitespace
                        $newTokens += $token -split ' '
                        break
                    }
                }
            }
            # Update tokens with the newly split parts
            $tokens = $newTokens
            Write-Verbose "Tokens after splitting by $style`: [$($tokens -join ', ')]"
        }
        Write-Verbose "Final result: [$($tokens -join ', ')]"
        $tokens
    }
}
