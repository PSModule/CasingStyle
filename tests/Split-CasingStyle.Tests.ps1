Describe 'Split-CasingStyle' {
    Context 'When splitting by a single casing style' {
        $testCases = @(
            @{ Text = 'this-is-a-kebab-case-string'; By = 'kebab-case'; Expected = 'this', 'is', 'a', 'kebab', 'case', 'string' }
            @{ Text = 'this_is_a_snake_case_string'; By = 'snake_case'; Expected = 'this', 'is', 'a', 'snake', 'case', 'string' }
            @{ Text = 'this_is_a_kebab_case_string'; By = 'snake_case'; Expected = 'this', 'is', 'a', 'kebab', 'case', 'string' }
            @{ Text = 'ThisIsAPascalCaseString'; By = 'PascalCase'; Expected = 'This', 'Is', 'A', 'Pascal', 'Case', 'String' }
            @{ Text = 'thisIsACamelCaseString'; By = 'camelCase'; Expected = 'this', 'Is', 'A', 'Camel', 'Case', 'String' }
            @{ Text = 'THIS-IS-AN-UPPER-KEBAB-STRING'; By = 'UPPER-KEBAB-CASE'; Expected = 'THIS', 'IS', 'AN', 'UPPER', 'KEBAB', 'STRING' }
            @{ Text = 'THIS_IS_AN_UPPER_SNAKE_STRING'; By = 'UPPER_SNAKE_CASE'; Expected = 'THIS', 'IS', 'AN', 'UPPER', 'SNAKE', 'STRING' }
        )

        It "Splits '<Text>' by '<By>' into individual words" -ForEach $testCases {
            $Text | Split-CasingStyle -By $By | Should -Be $Expected
        }
    }

    Context 'When the casing style has no separator of its own' {
        $testCases = @(
            @{ Text = 'This Is Title Case'; By = 'Title Case'; Expected = 'This', 'Is', 'Title', 'Case' }
            @{ Text = 'Sentencecase'; By = 'Sentencecase'; Expected = , 'Sentencecase' }
            @{ Text = 'lowercase'; By = 'lowercase'; Expected = , 'lowercase' }
            @{ Text = 'UPPERCASE'; By = 'UPPERCASE'; Expected = , 'UPPERCASE' }
        )

        It "Falls back to whitespace when splitting '<Text>' by '<By>'" -ForEach $testCases {
            $Text | Split-CasingStyle -By $By | Should -Be $Expected
        }
    }

    Context 'When the text holds no word the casing style recognizes' {
        $testCases = @(
            @{ Text = '123'; By = 'PascalCase' }
            @{ Text = '123'; By = 'camelCase' }
        )

        It "Returns '<Text>' unchanged when splitting by '<By>'" -ForEach $testCases {
            $Text | Split-CasingStyle -By $By | Should -Be $Text
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
