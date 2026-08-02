Describe 'Split-CasingStyle' {
    Context 'When splitting by a single casing style' {
        $testCases = @(
            @{ Text = 'this-is-a-kebab-case-string'; By = 'kebab-case'; Expected = 'this', 'is', 'a', 'kebab', 'case', 'string' }
            @{ Text = 'this_is_a_snake_case_string'; By = 'snake_case'; Expected = 'this', 'is', 'a', 'snake', 'case', 'string' }
            @{ Text = 'this_is_a_kebab_case_string'; By = 'snake_case'; Expected = 'this', 'is', 'a', 'kebab', 'case', 'string' }
            @{ Text = 'ThisIsAPascalCaseString'; By = 'PascalCase'; Expected = 'This', 'Is', 'A', 'Pascal', 'Case', 'String' }
            @{ Text = 'thisIsACamelCaseString'; By = 'camelCase'; Expected = 'this', 'Is', 'A', 'Camel', 'Case', 'String' }
        )

        It "Splits '<Text>' by '<By>' into individual words" -ForEach $testCases {
            $Text | Split-CasingStyle -By $By | Should -Be $Expected
        }
    }

    Context 'When splitting by several casing styles' {
        It "Splits 'this_is_a-PascalString' by snake_case, kebab-case and PascalCase" {
            'this_is_a-PascalString' |
                Split-CasingStyle -By 'snake_case', 'kebab-case', 'PascalCase' |
                Should -Be @('this', 'is', 'a', 'Pascal', 'String')
        }

        It 'Splits across a chain of Split-CasingStyle calls' {
            'this_is_a-CamelCaseString' |
                Split-CasingStyle -By 'kebab-case' |
                Split-CasingStyle -By 'snake_case', 'PascalCase' |
                Should -Be @('this', 'is', 'a', 'Camel', 'Case', 'String')
        }
    }
}
