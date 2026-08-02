Describe 'Get-CasingStyle' {
    Context 'When the text matches a known casing style' {
        $testCases = @(
            @{ Text = 't'; Expected = 'lowercase' }
            @{ Text = 'tttt'; Expected = 'lowercase' }
            @{ Text = 'testtest'; Expected = 'lowercase' }
            @{ Text = 'testtesttest'; Expected = 'lowercase' }
            @{ Text = 'T'; Expected = 'UPPERCASE' }
            @{ Text = 'TTTT'; Expected = 'UPPERCASE' }
            @{ Text = 'TESTTEST'; Expected = 'UPPERCASE' }
            @{ Text = 'TESTTESTTEST'; Expected = 'UPPERCASE' }
            @{ Text = 'Testtest'; Expected = 'Sentencecase' }
            @{ Text = 'Testtesttest'; Expected = 'Sentencecase' }
            @{ Text = 'Test Test'; Expected = 'Title Case' }
            @{ Text = 'Test Test Test'; Expected = 'Title Case' }
            @{ Text = 'TestTest'; Expected = 'PascalCase' }
            @{ Text = 'TestTestTest'; Expected = 'PascalCase' }
            @{ Text = 'ThisIsAMultiWordPascalString'; Expected = 'PascalCase' }
            @{ Text = 'tT'; Expected = 'camelCase' }
            @{ Text = 'testTest'; Expected = 'camelCase' }
            @{ Text = 'testTestTest'; Expected = 'camelCase' }
            @{ Text = 't-t'; Expected = 'kebab-case' }
            @{ Text = 'test-test'; Expected = 'kebab-case' }
            @{ Text = 'test-test-test'; Expected = 'kebab-case' }
            @{ Text = 'T-T'; Expected = 'UPPER-KEBAB-CASE' }
            @{ Text = 'TEST-TEST'; Expected = 'UPPER-KEBAB-CASE' }
            @{ Text = 'TEST-TEST-TEST'; Expected = 'UPPER-KEBAB-CASE' }
            @{ Text = 't_t'; Expected = 'snake_case' }
            @{ Text = 'test_test'; Expected = 'snake_case' }
            @{ Text = 'test_test_test'; Expected = 'snake_case' }
            @{ Text = 'TEST_TEST'; Expected = 'UPPER_SNAKE_CASE' }
            @{ Text = 'TEST_TEST_TEST'; Expected = 'UPPER_SNAKE_CASE' }
        )

        It "Detects '<Text>' as '<Expected>'" -ForEach $testCases {
            $Text | Get-CasingStyle | Should -Be $Expected
        }
    }

    Context 'When the text mixes separators and casing' {
        $testCases = @(
            @{ Text = 'Test_teSt-Test' }
            @{ Text = 'Test-Test_test' }
        )

        It "Detects '<Text>' as Unknown" -ForEach $testCases {
            $Text | Get-CasingStyle | Should -Be 'Unknown'
        }
    }
}
