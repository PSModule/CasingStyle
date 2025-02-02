Describe 'Module' {
    It 'Function: Set-PSModuleTest' {
        Set-PSModuleTest -Name 'World' | Should -Be 'Hello, World!'
    }
}
