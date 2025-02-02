filter Get-CasingStyle {
    <#
        .SYNOPSIS
        Detects the casing style of a string

        .DESCRIPTION
        This function detects the casing style of a string.

        .EXAMPLE
        'testtesttest' | Get-CasingStyle

        lowercase

        .EXAMPLE
        'TESTTESTTEST' | Get-CasingStyle

        UPPERCASE

        .EXAMPLE
        'Testtesttest' | Get-CasingStyle

        Sentencecase

        .EXAMPLE
        'TestTestTest' | Get-CasingStyle

        PascalCase

        .EXAMPLE
        'testTestTest' | Get-CasingStyle

        camelCase

        .EXAMPLE
        'test-test-test' | Get-CasingStyle

        kebab-case

        .EXAMPLE
        'TEST-TEST-TEST' | Get-CasingStyle

        UPPER-KEBAB-CASE

        .EXAMPLE
        'test_test_test' | Get-CasingStyle

        snake_case

        .EXAMPLE
        'TEST_TEST_TEST' | Get-CasingStyle

        UPPER_SNAKE_CASE

        .EXAMPLE
        'Test_teSt-Test' | Get-CasingStyle

        Unknown

        .OUTPUTS
        [string]

        The detected casing style of the input string.

        .LINK
        https://psmodule.io/Casing/Functions/Get-CasingStyle/
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        # The string to check the casing style of
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $Text
    )

    $style = if ([regex]::Match($Text, $script:LowerCase).Success) {
        'lowercase'
    } elseif ([regex]::Match($Text, $script:UpperCase).Success) {
        'UPPERCASE'
    } elseif ([regex]::Match($Text, $script:SentenceCase).Success) {
        'Sentencecase'
    } elseif ([regex]::Match($Text, $script:TitleCase).Success) {
        'Title Case'
    } elseif ([regex]::Match($Text, $script:PascalCase).Success) {
        'PascalCase'
    } elseif ([regex]::Match($Text, $script:CamelCase).Success) {
        'camelCase'
    } elseif ([regex]::Match($Text, $script:KebabCase).Success) {
        'kebab-case'
    } elseif ([regex]::Match($Text, $script:UpperKebabCase).Success) {
        'UPPER-KEBAB-CASE'
    } elseif ([regex]::Match($Text, $script:SnakeCase).Success) {
        'snake_case'
    } elseif ([regex]::Match($Text, $script:UpperSnakeCase).Success) {
        'UPPER_SNAKE_CASE'
    } else {
        'Unknown'
    }

    Write-Verbose "Detected casing style: [$style]"
    $style
}
