# Example usage of Get-CasingStyle
# Detects the casing style of various strings

'testtesttest' | Get-CasingStyle  # lowercase
'TESTTESTTEST' | Get-CasingStyle  # UPPERCASE
'Testtesttest' | Get-CasingStyle  # Sentencecase
'TestTestTest' | Get-CasingStyle  # PascalCase
'testTestTest' | Get-CasingStyle  # camelCase
'test-test-test' | Get-CasingStyle  # kebab-case
'TEST-TEST-TEST' | Get-CasingStyle  # UPPER-KEBAB-CASE
'test_test_test' | Get-CasingStyle  # snake_case
'TEST_TEST_TEST' | Get-CasingStyle  # UPPER_SNAKE_CASE
'Test_teSt-Test' | Get-CasingStyle  # Mixed case with special characters

# Example usage of ConvertTo-CasingStyle
# Converts a string to different casing styles

'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case'  # Converts to 'this_is_camel_case'
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE'  # Converts to 'THIS_IS_CAMEL_CASE'
'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case'  # Converts to 'this-is-camel-case'

# Example usage of Split-CasingStyle
# Splits a string based on different casing styles

Split-CasingStyle -Text 'this-is-a-kebab-case-string' -By 'kebab-case'  # Splits into words
Split-CasingStyle -Text 'this_is_a_kebab_case_string' -By 'snake_case'  # Splits into words
Split-CasingStyle -Text 'ThisIsAPascalCaseString' -By 'PascalCase'  # Splits into words
Split-CasingStyle -Text 'thisIsACamelCaseString' -By 'camelCase'  # Splits into words

# Chained splitting example
Split-CasingStyle -Text 'this_is_a-CamelCaseString' -By kebab-case | Split-CasingStyle -By snake_case  # Chained splitting

# Piped example with multiple styles
'this_is_a-PascalString' | Split-CasingStyle -By 'snake_case', 'kebab-case', 'PascalCase'
