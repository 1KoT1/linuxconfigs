source ~/.config/vim/.vimrc_cpp

let g:cmake_build_path_pattern = [ "../%s/build/%s", "g:cmake_selected_kit, g:cmake_build_type" ]
let g:cmake_vimspector_default_configuration = {
			\   'adapter': 'vscode-cpptools',
			\   'configuration': {
			\     'request': 'launch',
			\     'cwd': '${workspaceRoot}',
			\     'Mimode': '',
			\     'args': [],
			\     'program': '',
			\     'setupCommands': [
			\       {
			\         'description': 'Enable pretty-printing for gdb',
			\         'ignoreFailures': 'true',
			\         'text': '-enable-pretty-printing'
			\       }
			\     ]
			\   }
			\ }
