-- Полезная функция для быстрой установки keymap
local keymap = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = "DAP: " .. desc })
end

-- =============================================================================
-- 🛠  nvim-dap -- базовый плагин для поддержки отладки
-- =============================================================================
local has_dap, dap = pcall(require, 'dap')
if not has_dap then
	vim.notify('Plugin nvim-dap not loaded', vim.log.levels.ERROR)
	return false
end

dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

-- Вспомогательные функции для конфигурации dap плюс интеграция с cmake-tools
local has_cmake_tools, cmake_tools = pcall(require, 'cmake-tools')

local get_programm = has_cmake_tools and function()
	local target_path = cmake_tools.get_launch_target_path()
	if target_path == nil then
		cmake_tools.select_launch_target(true)
		target_path = cmake_tools.get_launch_target_path()
	end
	return target_path
end or function()
return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local get_args = has_cmake_tools and cmake_tools.get_launch_args or function()
	return {}
end

local get_programm_name = has_cmake_tools and function()
	local target = cmake_tools.get_launch_target()
	if target == nil then
		cmake_tools.select_launch_target(true)
		target = cmake_tools.get_launch_target()
	end
	return target
end or function()
return ''
end

local get_build_dir = has_cmake_tools and function()
	local build_dir = cmake_tools.get_config():prepare_build_directory(nil)

	if
		build_dir
		and vim.fn.isdirectory(build_dir) == 1 then
		return build_dir
	else
		return "${workspaceFolder}"
	end
end or function()
return "${workspaceFolder}"
end


-- Конфигурация dap
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = get_programm,
		args = get_args,
		cwd = get_build_dir,
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = get_programm,
		pid = function()
			local name = vim.fn.input('Executable name (filter): ', get_programm_name())
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = '${workspaceFolder}'
	},
	{
		name = 'Attach to gdbserver',
		type = 'gdb',
		request = 'attach',
		target = function()
			return vim.fn.input('Address of gdbserver: ', 'localhost:1234')
		end,
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}'
	}
}

-- Запуск, продолжение и перезапуск
keymap("n", "<F5>", dap.continue, "Запуск / Продолжить")
keymap("n", "<F17>", dap.terminate, "Остановить отладку (Shift+F5)") -- Shift+F5 часто передается как F17
keymap("n", "<Leader><F5>", dap.restart, "Перезапустить")

-- Шаги выполнения (Степпинг)
keymap("n", "<F10>", dap.step_over, "Шаг обхода (Step Over)")
keymap("n", "<F11>", dap.step_into, "Шаг внутрь (Step Into)")
keymap("n", "<F23>", dap.step_out, "Шаг наружу (Step Out) (Shift+F11)") -- Shift+F11 часто передается как F23

-- Точки останова (Breakpoints)
keymap("n", "<F9>", dap.toggle_breakpoint, "Переключить точку останова")
keymap("n", "<Leader><F9>", function()
	dap.set_breakpoint(vim.fn.input("Условие: "))
end, "Точка останова с условием")
keymap("n", "<F21>", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Лог-сообщение: "))
end, "Лог-точка (Log Point) (Shift+F9)") -- Shift+F9 часто передается как F21


-- =============================================================================
-- 🛠  nvim-dap-ui -- Пользовательский интерфейс для отладки
-- =============================================================================
local has_dapui, dapui = pcall(require, 'dapui')
if not has_dapui then
	vim.notify('Plugin nvim-dap-ui not loaded', vim.log.levels.ERROR)
	return false
end

dapui.setup({
	icons = {
		expanded = "▾",
		collapsed = "▸",
		current_frame = "▸"
	},
	controls = {
		enabled = true,
		element = "repl",
		icons = {
			pause = "⏸",
			play = "▶F5",
			step_into = "⇥F11",
			step_over = "⬇F10",
			-- step_over = "🡇",
			step_out = "↤Shift+F11",
			step_back = "|",
			-- step_back = "🡅",
			run_last = "⭮",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

-- Открывать UI на события dap
dap.listeners.before.attach.dapui_config = function()
	vim.cmd('tabnew')
	dapui.open()
end
dap.listeners.before.launch.dapui_config = dap.listeners.before.attach.dapui_config
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
	vim.cmd('tabclose')
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- vim.keymap.set(n, '<F5>', 

-- =============================================================================
-- 🛠  Всё настроено без ошибок. Возвращаю true, чтобы взывающий мог проверить
-- =============================================================================
return true
