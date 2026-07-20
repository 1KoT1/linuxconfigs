require("cmake-support")
require("cpp-debug-support")
require("cpp-tools").setup({})

vim.api.nvim_create_user_command( 'Build', 'CMakeBuild', { desc = 'Save and build a project' })
