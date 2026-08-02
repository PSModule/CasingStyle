Describe 'ConvertTo-CasingStyle' {
    Context 'When converting from camelCase' {
        $testCases = @(
            @{ To = 'lowercase'; Text = 'thisIsCamelCase'; Expected = 'thisiscamelcase' }
            @{ To = 'UPPERCASE'; Text = 'thisIsCamelCase'; Expected = 'THISISCAMELCASE' }
            @{ To = 'Sentencecase'; Text = 'thisIsCamelCase'; Expected = 'Thisiscamelcase' }
            @{ To = 'Title Case'; Text = 'thisIsCamelCase'; Expected = 'This Is Camel Case' }
            @{ To = 'PascalCase'; Text = 'thisIsCamelCase'; Expected = 'ThisIsCamelCase' }
            @{ To = 'camelCase'; Text = 'thisIsCamelCase'; Expected = 'thisIsCamelCase' }
            @{ To = 'kebab-case'; Text = 'thisIsCamelCase'; Expected = 'this-is-camel-case' }
            @{ To = 'UPPER-KEBAB-CASE'; Text = 'thisIsCamelCase'; Expected = 'THIS-IS-CAMEL-CASE' }
            @{ To = 'snake_case'; Text = 'thisIsCamelCase'; Expected = 'this_is_camel_case' }
            @{ To = 'UPPER_SNAKE_CASE'; Text = 'thisIsCamelCase'; Expected = 'THIS_IS_CAMEL_CASE' }
        )

        It "Converts '<Text>' to '<Expected>' using '<To>'" -ForEach $testCases {
            $Text | ConvertTo-CasingStyle -To $To | Should -Be $Expected
        }
    }

    Context 'When converting from other casing styles' {
        $testCases = @(
            @{ To = 'PascalCase'; Text = 'this-is-kebab-case'; Expected = 'ThisIsKebabCase' }
            @{ To = 'camelCase'; Text = 'this_is_snake_case'; Expected = 'thisIsSnakeCase' }
            @{ To = 'kebab-case'; Text = 'ThisIsPascalCase'; Expected = 'this-is-pascal-case' }
            @{ To = 'snake_case'; Text = 'TEST-TEST'; Expected = 'test_test' }
            @{ To = 'kebab-case'; Text = 'TEST_TEST'; Expected = 'test-test' }
            @{ To = 'snake_case'; Text = 'Test Test Test'; Expected = 'test_test_test' }
            @{ To = 'snake_case'; Text = 'Test  Test'; Expected = 'test_test' }
            @{ To = 'UPPERCASE'; Text = 'lowercase'; Expected = 'LOWERCASE' }
            @{ To = 'lowercase'; Text = 'UPPERCASE'; Expected = 'uppercase' }
            @{ To = 'PascalCase'; Text = 'Sentencecase'; Expected = 'Sentencecase' }
        )

        It "Converts '<Text>' to '<Expected>' using '<To>'" -ForEach $testCases {
            $Text | ConvertTo-CasingStyle -To $To | Should -Be $Expected
        }
    }

    Context 'When the input casing cannot be determined' {
        It "Throws because the ValidateSet in Split-CasingStyle will not accept 'Unknown'" {
            { 'Test_teSt-Test' | ConvertTo-CasingStyle -To 'snake_case' } | Should -Throw
        }
    }
}
