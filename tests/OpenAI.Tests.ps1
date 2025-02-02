# CasingModule.Tests.ps1
# ================================================
# Dot-source the module file containing your filters.
# Adjust the path as necessary.
. "$PSScriptRoot\CasingModule.ps1"

#--------------------------------------------------------------------
# Test Get-CasingStyle: verify that known inputs are detected correctly,
# and that ambiguous strings return 'Unknown'
#--------------------------------------------------------------------
Describe 'Get-CasingStyle Tests' {

    Context 'When given valid casing strings' {
        $testCases = @(
            @{ Input = 'testtest' ; Expected = 'lowercase' },
            @{ Input = 'TESTTEST' ; Expected = 'UPPERCASE' },
            @{ Input = 'Testtest' ; Expected = 'Sentencecase' },
            @{ Input = 'Test Test'; Expected = 'Title Case' },
            @{ Input = 'TestTest' ; Expected = 'PascalCase' },
            @{ Input = 'testTest' ; Expected = 'camelCase' },
            @{ Input = 'test-test'; Expected = 'kebab-case' },
            @{ Input = 'TEST-TEST'; Expected = 'UPPER-KEBAB-CASE' },
            @{ Input = 'test_test'; Expected = 'snake_case' },
            @{ Input = 'TEST_TEST'; Expected = 'UPPER_SNAKE_CASE' }
        )

        It "detects '<Input>' as '<Expected>)'" -ForEach $testCases {
            $result = $Input | Get-CasingStyle
            $result | Should -Be $Expected
        }
    }

    Context 'When given an ambiguous or unsupported string' {
        It "returns 'Unknown'" {
            'Test_teSt-Test' | Get-CasingStyle | Should -Be 'Unknown'
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

    It 'splits a kebab-case string into individual words' {
        $inputText = 'this-is-a-kebab-case-string'
        $expected = 'this', 'is', 'a', 'kebab', 'case', 'string'
        $result = $inputText | Split-CasingStyle -By 'kebab-case'
        $result | Should -Be $expected
    }

    It 'splits a snake_case string into individual words' {
        $inputText = 'this_is_a_snake_case_string'
        $expected = 'this', 'is', 'a', 'snake', 'case', 'string'
        $result = $inputText | Split-CasingStyle -By 'snake_case'
        $result | Should -Be $expected
    }

    It 'splits a PascalCase string into individual words' {
        $inputText = 'ThisIsAPascalCaseString'
        $expected = 'This', 'Is', 'A', 'Pascal', 'Case', 'String'
        $result = $inputText | Split-CasingStyle -By 'PascalCase'
        $result | Should -Be $expected
    }

    It 'splits a camelCase string into individual words' {
        $inputText = 'thisIsACamelCaseString'
        $expected = 'this', 'Is', 'A', 'Camel', 'Case', 'String'
        $result = $inputText | Split-CasingStyle -By 'camelCase'
        $result | Should -Be $expected
    }

    It 'handles multiple splitting criteria in succession' {
        # In this example the string is first split on snake_case,
        # then on kebab-case, and finally on PascalCase.
        # Explanation:
        #   • 'this_is_a-PascalString' → snake_case splits to: 'this', 'is', 'a-PascalString'
        #   • Then kebab-case splits 'a-PascalString' into 'a' and 'PascalString'
        #   • Then PascalCase splits 'PascalString' into 'Pascal' and 'String'
        $inputText = 'this_is_a-PascalString'
        $expected = 'this', 'is', 'a', 'Pascal', 'String'
        $result = $inputText | Split-CasingStyle -By 'snake_case', 'kebab-case', 'PascalCase'
        $result | Should -Be $expected
    }
}
