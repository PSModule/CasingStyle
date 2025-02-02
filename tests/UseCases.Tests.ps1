#--------------------------------------------------------------------
# Test Get-CasingStyle: verify that known inputs are detected correctly,
# and that ambiguous strings return 'Unknown'
#--------------------------------------------------------------------
Describe 'Get-CasingStyle Tests' {

    Context 'When given valid casing strings' {
        $testCases = @(
            @{ Text = 'testtest'      ; Expected = 'lowercase' },
            @{ Text = 'TESTTEST'      ; Expected = 'UPPERCASE' },
            @{ Text = 'Testtest'      ; Expected = 'Sentencecase' },
            @{ Text = 'Test Test'     ; Expected = 'Title Case' },
            @{ Text = 'TestTest'      ; Expected = 'PascalCase' },
            @{ Text = 'testTest'      ; Expected = 'camelCase' },
            @{ Text = 'test-test'     ; Expected = 'kebab-case' },
            @{ Text = 'TEST-TEST'     ; Expected = 'UPPER-KEBAB-CASE' },
            @{ Text = 'test_test'     ; Expected = 'snake_case' },
            @{ Text = 'TEST_TEST'     ; Expected = 'UPPER_SNAKE_CASE' }
            @{ Text = 'Test_teSt-Test'; Expected = 'Unknown' }
        )

        It "detects '<Text>' as '<Expected>)'" -ForEach $testCases {
            $Text | Get-CasingStyle | Should -Be $Expected
        }
    }
}

#--------------------------------------------------------------------
# Test ConvertTo-CasingStyle: verify that converting a sample string
# (here, in camelCase) to each target style produces the expected output.
# Also verify that conversion fails when the input style is unknown.
#--------------------------------------------------------------------
Describe 'ConvertTo-CasingStyle Tests' {

    Context 'Converting from camelCase' {
        # Our sample input is in camelCase.
        $testCases = @(
            @{ Name = 'lowercase'        ; Text = 'thisIsCamelCase' ; Expected = 'thisiscamelcase' }
            @{ Name = 'UPPERCASE'        ; Text = 'thisIsCamelCase' ; Expected = 'THISISCAMELCASE' }
            @{ Name = 'Sentencecase'     ; Text = 'thisIsCamelCase' ; Expected = 'Thisiscamelcase' }
            @{ Name = 'Title Case'       ; Text = 'thisIsCamelCase' ; Expected = 'This Is Camel Case' }
            @{ Name = 'PascalCase'       ; Text = 'thisIsCamelCase' ; Expected = 'ThisIsCamelCase' }
            @{ Name = 'camelCase'        ; Text = 'thisIsCamelCase' ; Expected = 'thisIsCamelCase' }
            @{ Name = 'kebab-case'       ; Text = 'thisIsCamelCase' ; Expected = 'this-is-camel-case' }
            @{ Name = 'UPPER-KEBAB-CASE' ; Text = 'thisIsCamelCase' ; Expected = 'THIS-IS-CAMEL-CASE' }
            @{ Name = 'snake_case'       ; Text = 'thisIsCamelCase' ; Expected = 'this_is_camel_case' }
            @{ Name = 'UPPER_SNAKE_CASE' ; Text = 'thisIsCamelCase' ; Expected = 'THIS_IS_CAMEL_CASE' }
        )

        It "converts '<Text>' to '<Expected>' using '<Name>'" -ForEach $testCases {
            $result = $Text | ConvertTo-CasingStyle -To $Name
            $result | Should -Be $Expected
        }
    }

    Context 'When the input casing cannot be determined' {
        It "throws an error because the ValidateSet in Split-CasingStyle will not accept 'Unknown'" {
            { 'Test_teSt-Test' | ConvertTo-CasingStyle -To 'snake_case' } | Should -Throw
        }
    }
}

#--------------------------------------------------------------------
# Test Split-CasingStyle: verify that the function correctly splits
# strings according to the provided casing style(s)
#--------------------------------------------------------------------
Describe 'Split-CasingStyle Tests' {

    $testCases = @(
        @{ Text = 'this-is-a-kebab-case-string'; SplitBy = 'kebab-case' ; Expected = 'this', 'is', 'a', 'kebab', 'case', 'string' }
        @{ Text = 'this_is_a_snake_case_string' ; SplitBy = 'snake_case' ; Expected = 'this', 'is', 'a', 'snake', 'case', 'string' }
        @{ Text = 'ThisIsAPascalCaseString' ; SplitBy = 'PascalCase' ; Expected = 'This', 'Is', 'A', 'Pascal', 'Case', 'String' }
        @{ Text = 'thisIsACamelCaseString' ; SplitBy = 'camelCase' ; Expected = 'this', 'Is', 'A', 'Camel', 'Case', 'String' }
        @{ Text = 'this_is_a-PascalString' ; SplitBy = 'snake_case', 'kebab-case', 'PascalCase' ; Expected = 'this', 'is', 'a', 'Pascal', 'String' }
    )

    It 'splits <Text> using <SplitBy> into individual words' -ForEach $testCases {
        $Text | Split-CasingStyle -By $SplitBy | Should -Be $expected
    }
}
