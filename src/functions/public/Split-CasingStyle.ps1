function Split-CasingStyle {
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

        this
        is
        a
        Pascal
        String

        .INPUTS
        System.String

        The text to split, piped in.

        .OUTPUTS
        System.String

        Each word found in the text, emitted one at a time.

        .LINK
        https://psmodule.io/CasingStyle/Functions/Split-CasingStyle/
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # The string to split
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $Text,

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
        [string[]] $By
    )

    process {
        Write-Verbose "Starting with string: [$Text]"
        # Start with the original text as the only token.
        $tokens = @($Text)

        # For each casing style in the -By list, split every token accordingly.
        foreach ($style in $By) {
            Write-Verbose "Splitting by casing style: $style"
            $newTokens = [System.Collections.Generic.List[string]]::new()
            foreach ($token in $tokens) {
                switch ($style) {
                    'PascalCase' {
                        # Use regex to match sequences like 'Pascal' and 'String' in 'PascalString'
                        $matchedTokens = [regex]::Matches($token, '([A-Z][a-z]*)')
                        if ($matchedTokens.Count -gt 0) {
                            $newTokens.AddRange([string[]]($matchedTokens | ForEach-Object { $_.Value }))
                        } else {
                            $newTokens.Add($token)
                        }
                        break
                    }
                    'camelCase' {
                        # Match leading lowercase or uppercase letter groups
                        $matchedTokens = [regex]::Matches($token, '(^[a-z]+|[A-Z][a-z]*)')
                        if ($matchedTokens.Count -gt 0) {
                            $newTokens.AddRange([string[]]($matchedTokens | ForEach-Object { $_.Value }))
                        } else {
                            $newTokens.Add($token)
                        }
                        break
                    }
                    'kebab-case' {
                        $newTokens.AddRange($token.Split('-', [StringSplitOptions]::RemoveEmptyEntries))
                        break
                    }
                    'UPPER-KEBAB-CASE' {
                        $newTokens.AddRange($token.Split('-', [StringSplitOptions]::RemoveEmptyEntries))
                        break
                    }
                    'snake_case' {
                        $newTokens.AddRange($token.Split('_', [StringSplitOptions]::RemoveEmptyEntries))
                        break
                    }
                    'UPPER_SNAKE_CASE' {
                        $newTokens.AddRange($token.Split('_', [StringSplitOptions]::RemoveEmptyEntries))
                        break
                    }
                    default {
                        # Styles that carry no separator fall back to whitespace. Get-CasingStyle
                        # detects 'Title Case' with '\s+', so this has to match any whitespace run.
                        $newTokens.AddRange($token.Split([char[]]$null, [StringSplitOptions]::RemoveEmptyEntries))
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
