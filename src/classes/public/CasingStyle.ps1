# Base class for all casing styles
class CasingStyle {
    [string]$Name
    [string]$CasedName
    [string]$Pattern
    [string]$Characteristics
    [string]$Example
    [bool]$Splittable
    [string]$Reason
    [string]$Delimiter
    [bool]$IsDelimiterBased
    [string[]]$Aliases
    [string]$TypicalUsage

    CasingStyle(
        [string]$Name,
        [string]$CasedName,
        [string]$Pattern,
        [string]$Characteristics,
        [string]$Example,
        [bool]$Splittable,
        [string]$Reason,
        [string]$Delimiter,
        [bool]$IsDelimiterBased,
        [string[]]$Aliases,
        [string]$TypicalUsage
    ) {
        $this.Name = $Name
        $this.CasedName = $CasedName
        $this.Pattern = $Pattern
        $this.Characteristics = $Characteristics
        $this.Example = $Example
        $this.Splittable = $Splittable
        $this.Reason = $Reason
        $this.Delimiter = $Delimiter
        $this.IsDelimiterBased = $IsDelimiterBased
        $this.Aliases = $Aliases
        $this.TypicalUsage = $TypicalUsage
    }

    # Methos to output the class as a string
    [string] ToString() {
        return $($this.Name)
    }

    [string[]] ToWords([string]$inputText) {
        throw [System.NotImplementedException] 'ToWords() must be implemented by the derived class.'
    }

    [string] FromWords([string[]]$words) {
        throw [System.NotImplementedException] 'FromWords() must be implemented by the derived class.'
    }
}

# Derived class for delimiter-based casing styles (e.g. snake_case, kebab-case)
class DelimiterCasingStyle : CasingStyle {
    DelimiterCasingStyle(
        [string]$Name,
        [string]$CasedName,
        [string]$Pattern,
        [string]$Characteristics,
        [string]$Example,
        [bool]$Splittable,
        [string]$Reason,
        [string]$Delimiter,
        [string[]]$Aliases,
        [string]$TypicalUsage
    )
    : base($Name, $CasedName, $Pattern, $Characteristics, $Example, $Splittable, $Reason, $Delimiter, $true, $Aliases, $TypicalUsage) {
    }

    [string[]] ToWords([string]$inputText) {
        # Use the delimiter to split the string
        return $inputText -split ([regex]::Escape($this.Delimiter))
    }

    [string] FromWords([string[]]$words) {
        # Join words with the delimiter
        return $words -join $this.Delimiter
    }
}

# Derived class for PascalCase style
class PascalCaseStyle : CasingStyle {
    PascalCaseStyle() : base(
        'PascalCase',
        'PascalCase',
        '^[A-Z][a-z0-9]*([A-Z][a-z0-9]*)+$',
        'Each word starts with an uppercase letter and no delimiters are used.',
        'TheQuickBrownFox',
        $true,
        'Capital letters indicate the beginning of a new word.',
        $null,
        $false,
        @(),
        'Commonly used for class names and type names.'
    ) {
    }

    [string[]] ToWords([string]$inputText) {
        # Match sequences that start with an uppercase letter
        return [regex]::Matches($inputText, '[A-Z][a-z0-9]*') | ForEach-Object { $_.Value }
    }

    [string] FromWords([string[]]$words) {
        $result = ''
        foreach ($word in $words) {
            if ($word.Length -gt 0) {
                $result += $word.Substring(0, 1).ToUpper() + $word.Substring(1).ToLower()
            }
        }
        return $result
    }
}

# Derived class for CamelCase style
class CamelCaseStyle : CasingStyle {
    CamelCaseStyle() : base(
        'CamelCase',
        'camelCase',
        '^[a-z][a-z0-9]*([A-Z][a-z0-9]*)+$',
        'First word is lowercase, subsequent words start with an uppercase letter; no delimiters.',
        'theQuickBrownFox',
        $true,
        'The transition from lowercase to uppercase indicates a new word.',
        $null,
        $false,
        @(),
        'Often used for variable and function names.'
    ) {
    }

    [string[]] ToWords([string]$inputText) {
        # Match the initial lowercase sequence and then subsequent capitalized parts.
        return [regex]::Matches($inputText, '(^[a-z0-9]+)|([A-Z][a-z0-9]*)') | ForEach-Object { $_.Value }
    }

    [string] FromWords([string[]]$words) {
        if ($words.Count -eq 0) { return '' }
        $first = $words[0].ToLower()
        $rest = $words[1..($words.Count - 1)] | ForEach-Object {
            if ($_.Length -gt 0) {
                $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower()
            } else { $_ }
        }
        return $first + ($rest -join '')
    }
}

# Derived class for KebabCase style (using DelimiterCasingStyle)
class KebabCaseStyle : DelimiterCasingStyle {
    KebabCaseStyle() : base(
        'KebabCase',
        'kebab-case',
        '^[a-z][a-z0-9]*(-[a-z0-9]+)+$',
        'All words are lowercase and separated by hyphens.',
        'the-quick-brown-fox',
        $true,
        'Hyphen is used as a delimiter to separate words.',
        '-',
        @(),
        'Commonly used for URLs, CSS classes, and file names.'
    ) {
    }
}

# Derived class for SnakeCase style (using DelimiterCasingStyle)
class SnakeCaseStyle : DelimiterCasingStyle {
    SnakeCaseStyle() : base(
        'SnakeCase',
        'snake_case',
        '^[a-z][a-z0-9]*(_[a-z0-9]+)+$',
        'All words are lowercase and separated by underscores.',
        'the_quick_brown_fox',
        $true,
        'Underscore acts as a delimiter for words.',
        '_',
        @(),
        'Commonly used for variable names in languages like Python and Ruby.'
    ) {
    }
}

# Example usage:
# Create instances of the styles and call their methods.

$pascal = [PascalCaseStyle]::new()
Write-Output 'PascalCase Example:'
Write-Output "Original: $($pascal.Example)"
$words = $pascal.ToWords($pascal.Example)
Write-Output "Words: $words"
Write-Output "Reassembled: $($pascal.FromWords($words))"
Write-Output ''

$camel = [CamelCaseStyle]::new()
Write-Output 'CamelCase Example:'
Write-Output "Original: $($camel.Example)"
$words = $camel.ToWords($camel.Example)
Write-Output "Words: $words"
Write-Output "Reassembled: $($camel.FromWords($words))"
Write-Output ''

$kebab = [KebabCaseStyle]::new()
Write-Output 'KebabCase Example:'
Write-Output "Original: $($kebab.Example)"
$words = $kebab.ToWords($kebab.Example)
Write-Output "Words: $words"
Write-Output "Reassembled: $($kebab.FromWords($words))"
Write-Output ''

$snake = [SnakeCaseStyle]::new()
Write-Output 'SnakeCase Example:'
Write-Output "Original: $($snake.Example)"
$words = $snake.ToWords($snake.Example)
Write-Output "Words: $words"
Write-Output "Reassembled: $($snake.FromWords($words))"
