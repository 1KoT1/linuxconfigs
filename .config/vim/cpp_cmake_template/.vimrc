source ~/.config/vim/.vimrc_cpp

let $Poco_DIR = '/opt/poco/poco-1.7.2'
let $LD_LIBRARY_PATH = '/opt/poco/poco-1.7.2/lib'

let g:cmake_compile_commands_link = '../compile_commands.json'

let g:ep5_project_name = "tvm_offline"
let g:ep5_source_dir = getcwd()
let g:ep5_toolchain = "/opt/toolchains/stbgcc-4.8-1.6"
let g:ep5_fw_build_dir = "/home/vasilii/src/build_ep5"
"compiler ep5
