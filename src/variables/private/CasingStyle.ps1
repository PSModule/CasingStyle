$script:CasingStyle = [pscustomobject]@{
    LowerCase      = [pscustomobject]@{
        Name             = 'LowerCase'
        CasedName        = 'lowercase'
        Pattern          = '^[a-z][a-z0-9]*$'
        Characteristics  = 'All characters are in lowercase.'
        Example          = 'thequickbrownfoxjumpsoverthelazydog'
        Splittable       = $false
        Reason           = 'No delimiters or capitalization changes to indicate word boundaries.'
        Delimiter        = $null
        IsDelimiterBased = $false
        TypicalUsage     = 'Identifiers without explicit word boundaries.'
        Aliases          = @()
    }
    UpperCase      = [pscustomobject]@{
        Name             = 'UpperCase'
        CasedName        = 'UPPERCASE'
        Pattern          = '^[A-Z][A-Z0-9]*$'
        Characteristics  = 'All characters are in uppercase.'
        Example          = 'THEQUICKBROWNFOXJUMPSOVERTHELAZYDOG'
        Splittable       = $false
        Reason           = 'No delimiters or capitalization changes to indicate word boundaries.'
        Delimiter        = $null
        IsDelimiterBased = $false
        TypicalUsage     = 'Constants or identifiers where uniform casing is desired.'
        Aliases          = @()
    }
    SentenceCase   = [pscustomobject]@{
        Name             = 'SentenceCase'
        CasedName        = 'Sentence case'
        # Updated regex to allow for multiple words separated by spaces.
        Pattern          = '^[A-Z][a-z0-9]*(\s+[a-z0-9]+)*$'
        Characteristics  = 'The first character is uppercase; subsequent words (if any) are lowercase or digits and separated by spaces.'
        Example          = 'The quick brown fox jumps over the lazy dog'
        Splittable       = $true
        Reason           = 'Spaces act as word delimiters.'
        Delimiter        = ' '
        IsDelimiterBased = $true
        TypicalUsage     = 'User-facing sentences or prose titles.'
        Aliases          = @('Normal Sentence Case')
    }
    TitleCase      = [pscustomobject]@{
        Name             = 'TitleCase'
        CasedName        = 'Title Case'
        Pattern          = '^([A-Z][a-z]*)+(\s+[A-Z][a-z]*)*$'
        Characteristics  = 'Each word starts with an uppercase letter; words are separated by spaces.'
        Example          = 'The Quick Brown Fox Jumps Over The Lazy Dog'
        Splittable       = $true
        Reason           = 'Spaces separate capitalized words.'
        Delimiter        = ' '
        IsDelimiterBased = $true
        TypicalUsage     = 'Headlines, titles, and stylized labels.'
        Aliases          = @()
    }
    PascalCase     = [pscustomobject]@{
        Name             = 'PascalCase'
        CasedName        = 'PascalCase'
        Pattern          = '^[A-Z][a-z0-9]*([A-Z][a-z0-9]*)+$'
        Characteristics  = 'Each word starts with an uppercase letter; no separators are used.'
        Example          = 'TheQuickBrownFoxJumpsOverTheLazyDog'
        Splittable       = $true
        Reason           = 'Capital letters denote word boundaries.'
        Delimiter        = $null
        IsDelimiterBased = $false
        ToWords          = { param($str) [regex]::Matches($str, '[A-Z][a-z0-9]*') | ForEach-Object { $_.Value } }
        FromWords        = {
            param($words)
            ($words | ForEach-Object {
                if ($_.Length -gt 0) {
                    $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower()
                } else {
                    $_
                }
            }) -join ''
        }
        TypicalUsage     = 'Class names, type names, and other identifiers in many programming languages.'
        Aliases          = @()
    }
    CamelCase      = [pscustomobject]@{
        Name             = 'CamelCase'
        CasedName        = 'camelCase'
        Pattern          = '^[a-z][a-z0-9]*([A-Z][a-z0-9]*)+$'
        Characteristics  = 'The first word is in lowercase; subsequent words begin with an uppercase letter; no separators are used.'
        Example          = 'theQuickBrownFoxJumpsOverTheLazyDog'
        Splittable       = $true
        Reason           = 'Word boundaries are indicated by a change from lowercase to uppercase.'
        Delimiter        = $null
        IsDelimiterBased = $false
        ToWords          = {
            param($str)
            # Matches the leading lowercase word and subsequent capitalized words.
            [regex]::Matches($str, '(^[a-z0-9]+)|([A-Z][a-z0-9]*)') | ForEach-Object { $_.Value }
        }
        FromWords        = {
            param($words)
            if ($words.Count -gt 0) {
                $first = $words[0].ToLower()
                $rest = $words[1..($words.Count - 1)] | ForEach-Object {
                    if ($_.Length -gt 0) {
                        $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower()
                    } else {
                        $_
                    }
                }
                return $first + ($rest -join '')
            } else {
                return ''
            }
        }
        TypicalUsage     = 'Variable names and function names in many programming languages.'
        Aliases          = @()
    }
    KebabCase      = [pscustomobject]@{
        Name             = 'KebabCase'
        CasedName        = 'kebab-case'
        Pattern          = '^[a-z][a-z0-9]*(-[a-z0-9]+)+$'
        Characteristics  = 'All words are in lowercase and separated by hyphens.'
        Example          = 'the-quick-brown-fox-jumps-over-the-lazy-dog'
        Splittable       = $true
        Reason           = 'Hyphens act as clear word delimiters.'
        Delimiter        = '-'
        IsDelimiterBased = $true
        ToWords          = { param($str) $str -split '-' }
        FromWords        = { param($words) $words -join '-' }
        TypicalUsage     = 'URLs, filenames, and CSS classes.'
        Aliases          = @()
    }
    UpperKebabCase = [pscustomobject]@{
        Name             = 'UpperKebabCase'
        CasedName        = 'UPPER-KEBAB-CASE'
        Pattern          = '^[A-Z][A-Z0-9]*(-[A-Z0-9]+)+$'
        Characteristics  = 'All words are in uppercase and separated by hyphens.'
        Example          = 'THE-QUICK-BROWN-FOX-JUMPS-OVER-THE-LAZY-DOG'
        Splittable       = $true
        Reason           = 'Hyphens act as clear word delimiters.'
        Delimiter        = '-'
        IsDelimiterBased = $true
        ToWords          = { param($str) $str -split '-' }
        FromWords        = { param($words) ($words | ForEach-Object { $_.ToUpper() }) -join '-' }
        TypicalUsage     = 'Constants or identifiers where uppercase is preferred.'
        Aliases          = @('Screaming Kebab Case')
    }
    SnakeCase      = [pscustomobject]@{
        Name             = 'SnakeCase'
        CasedName        = 'snake_case'
        Pattern          = '^[a-z][a-z0-9]*(_[a-z0-9]+)+$'
        Characteristics  = 'All words are in lowercase and separated by underscores.'
        Example          = 'the_quick_brown_fox_jumps_over_the_lazy_dog'
        Splittable       = $true
        Reason           = 'Underscores indicate word boundaries.'
        Delimiter        = '_'
        IsDelimiterBased = $true
        ToWords          = { param($str) $str -split '_' }
        FromWords        = { param($words) $words -join '_' }
        TypicalUsage     = 'Variable names in languages like Python and Ruby.'
        Aliases          = @()
    }
    UpperSnakeCase = [pscustomobject]@{
        Name             = 'UpperSnakeCase'
        CasedName        = 'UPPER_SNAKE_CASE'
        Pattern          = '^[A-Z][A-Z0-9]*(_[A-Z0-9]+)+$'
        Characteristics  = 'All words are in uppercase and separated by underscores.'
        Example          = 'THE_QUICK_BROWN_FOX_JUMPS_OVER_THE_LAZY_DOG'
        Splittable       = $true
        Reason           = 'Underscores indicate word boundaries.'
        Delimiter        = '_'
        IsDelimiterBased = $true
        ToWords          = { param($str) $str -split '_' }
        FromWords        = { param($words) ($words | ForEach-Object { $_.ToUpper() }) -join '_' }
        TypicalUsage     = 'Constants in many programming languages.'
        Aliases          = @('Screaming Snake Case')
    }
}
