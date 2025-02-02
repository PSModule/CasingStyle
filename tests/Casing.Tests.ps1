Describe 'Casing' {
    Context 'Function: Get-CasingStyle' {
        It "Get-CasingStyle: Detects 'testtesttest' as lowercase" {
            'testtesttest' | Get-CasingStyle | Should -Be 'lowercase'
        }

        It "Get-CasingStyle: Detects 'TESTTESTTEST' as UPPERCASE" {
            'TESTTESTTEST' | Get-CasingStyle | Should -Be 'UPPERCASE'
        }

        It "Get-CasingStyle: Detects 'Testtesttest' as Sentencecase" {
            'Testtesttest' | Get-CasingStyle | Should -Be 'Sentencecase'
        }

        It "Get-CasingStyle: Detects 'TestTestTest' as PascalCase" {
            'TestTestTest' | Get-CasingStyle | Should -Be 'PascalCase'
        }

        It "Get-CasingStyle: Detects 'testTestTest' as camelCase" {
            'testTestTest' | Get-CasingStyle | Should -Be 'camelCase'
        }

        It "Get-CasingStyle: Detects 'test-test-test' as kebab-case" {
            'test-test-test' | Get-CasingStyle | Should -Be 'kebab-case'
        }

        It "Get-CasingStyle: Detects 'TEST-TEST-TEST' as UPPER-KEBAB-CASE" {
            'TEST-TEST-TEST' | Get-CasingStyle | Should -Be 'UPPER-KEBAB-CASE'
        }

        It "Get-CasingStyle: Detects 'test_test_test' as snake_case" {
            'test_test_test' | Get-CasingStyle | Should -Be 'snake_case'
        }

        It "Get-CasingStyle: Detects 'TEST_TEST_TEST' as UPPER_SNAKE_CASE" {
            'TEST_TEST_TEST' | Get-CasingStyle | Should -Be 'UPPER_SNAKE_CASE'
        }

        It "Get-CasingStyle: Detects 'Test Test Test' as Title Case" {
            'Test Test Test' | Get-CasingStyle | Should -Be 'Title Case'
        }

        It "Get-CasingStyle: Detects 'Test_teSt-Test' as Unknown" {
            'Test_teSt-Test' | Get-CasingStyle | Should -Be 'Unknown'
        }

        It "Get-CasingStyle: Detects 'Test-Test_test' as Unknown" {
            'Test-Test_test' | Get-CasingStyle | Should -Be 'Unknown'
        }

        It "Get-CasingStyle: Detects 'ThisIsAMultiWordPascalString' as PascalCase" {
            'ThisIsAMultiWordPascalString' | Get-CasingStyle | Should -Be 'PascalCase'
        }

        It "Get-CasingStyle: Detects 'T' as UPPERCASE" {
            'T' | Get-CasingStyle | Should -Be 'UPPERCASE'
        }

        It "Get-CasingStyle: Detects 'TTTT' UPPERCASE" {
            'TTTT' | Get-CasingStyle | Should -Be 'UPPERCASE'
        }

        It "Get-CasingStyle: Detects 't' as lowercase" {
            't' | Get-CasingStyle | Should -Be 'lowercase'
        }

        It "Get-CasingStyle: Detects 'tttt' as lowercase" {
            'tttt' | Get-CasingStyle | Should -Be 'lowercase'
        }

        It "Get-CasingStyle: Detects 'tT' as camelCase" {
            'tT' | Get-CasingStyle | Should -Be 'camelCase'
        }

        It "Get-CasingStyle: Detects 't-t' as kebab-case" {
            't-t' | Get-CasingStyle | Should -Be 'kebab-case'
        }

        It "Get-CasingStyle: Detects 'T-T' as UPPER-KEBAB-CASE" {
            'T-T' | Get-CasingStyle | Should -Be 'UPPER-KEBAB-CASE'
        }

        It "Get-CasingStyle: Detects 't_t' as snake_case" {
            't_t' | Get-CasingStyle | Should -Be 'snake_case'
        }
    }
    Context 'Function: ConvertTo-CasingStyle' {
        It "ConvertTo-CasingStyle: Converts 'thisIsCamelCase' to 'snake_case'" {
            'thisIsCamelCase' | ConvertTo-CasingStyle -To 'snake_case' | Should -Be 'this_is_camel_case'
        }

        It "ConvertTo-CasingStyle: Converts 'thisIsCamelCase' to 'THIS_IS_CAMEL_CASE'" {
            'thisIsCamelCase' | ConvertTo-CasingStyle -To 'UPPER_SNAKE_CASE' | Should -Be 'THIS_IS_CAMEL_CASE'
        }

        It "ConvertTo-CasingStyle: Converts 'thisIsCamelCase' to 'this-is-camel-case'" {
            'thisIsCamelCase' | ConvertTo-CasingStyle -To 'kebab-case' | Should -Be 'this-is-camel-case'
        }
    }
    Context 'Function: Split-CasingStyle' {
        It "Split-CasingStyle: Splits 'this_is_a_kebab_case_string' by 'snake_case'" {
            'this_is_a_kebab_case_string' | Split-CasingStyle -By 'snake_case' | Should -Be @('this', 'is', 'a', 'kebab', 'case', 'string')
        }

        It "Split-CasingStyle: Splits 'ThisIsAPascalCaseString' by 'PascalCase'" {
            'ThisIsAPascalCaseString' | Split-CasingStyle -By 'PascalCase' | Should -Be @('This', 'Is', 'A', 'Pascal', 'Case', 'String')
        }

        It "Split-CasingStyle: Splits 'thisIsACamelCaseString' by 'camelCase'" {
            'thisIsACamelCaseString' | Split-CasingStyle -By 'camelCase' | Should -Be @('this', 'Is', 'A', 'Camel', 'Case', 'String')
        }

        It "Split-CasingStyle: Splits 'this_is_a-CamelCaseString' by kebab-case | Split-CasingStyle -By snake_case" {
            'this_is_a-CamelCaseString' |
                Split-CasingStyle -By kebab-case |
                Split-CasingStyle -By snake_case |
                Should -Be @('this_is_a', 'camelcasestring')
        }

        It "Split-CasingStyle: Splits 'this-is-a-kebab-case-string' by kebab-case" {
            'this-is-a-kebab-case-string' | Split-CasingStyle -By kebab-case | Should -Be @('this', 'is', 'a', 'kebab', 'case', 'string')
        }
    }
}
