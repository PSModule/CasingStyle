<#
    .SYNOPSIS
    Detecting, converting, and splitting casing styles with CasingStyle.
#>

Import-Module -Name CasingStyle

# Detect the casing style of a string.
'testtesttest' | Get-CasingStyle       # lowercase
'TESTTESTTEST' | Get-CasingStyle       # UPPERCASE
'Testtesttest' | Get-CasingStyle       # Sentencecase
'Test Test Test' | Get-CasingStyle     # Title Case
'TestTestTest' | Get-CasingStyle       # PascalCase
'testTestTest' | Get-CasingStyle       # camelCase
'test-test-test' | Get-CasingStyle     # kebab-case
'TEST-TEST-TEST' | Get-CasingStyle     # UPPER-KEBAB-CASE
'test_test_test' | Get-CasingStyle     # snake_case
'TEST_TEST_TEST' | Get-CasingStyle     # UPPER_SNAKE_CASE
'Test_teSt-Test' | Get-CasingStyle     # Unknown - separators and casing are mixed

# Convert a string to another casing style. The source style is detected for you.
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'        # this_is_camel_case
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE'  # THIS_IS_CAMEL_CASE
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case'        # this-is-camel-case
'this-is-kebab-case' | ConvertTo-CasingStyle -To 'PascalCase'     # ThisIsKebabCase

# Split a string into the words its casing encodes.
Split-CasingStyle -Text 'this-is-a-kebab-case-string' -By 'kebab-case'
Split-CasingStyle -Text 'this_is_a_snake_case_string' -By 'snake_case'
Split-CasingStyle -Text 'ThisIsAPascalCaseString' -By 'PascalCase'
Split-CasingStyle -Text 'thisIsACamelCaseString' -By 'camelCase'

# Pass several styles when the text mixes them, or chain the calls.
'this_is_a-PascalString' | Split-CasingStyle -By 'snake_case', 'kebab-case', 'PascalCase'
Split-CasingStyle -Text 'this_is_a-CamelCaseString' -By 'kebab-case' | Split-CasingStyle -By 'snake_case'

# Scenario: an API returns snake_case property names and you want a PowerShell-shaped object.
$response = [pscustomobject]@{
    user_name     = 'octocat'
    created_at    = '2024-01-01'
    is_site_admin = $false
}

$normalized = [ordered]@{}
foreach ($property in $response.PSObject.Properties) {
    $normalized[(ConvertTo-CasingStyle -Text $property.Name -To 'PascalCase')] = $property.Value
}
[pscustomobject]$normalized                                       # UserName, CreatedAt, IsSiteAdmin

# Scenario: turn a command name into a human-readable heading.
(Split-CasingStyle -Text 'ConvertTo-CasingStyle' -By 'kebab-case', 'PascalCase') -join ' '
