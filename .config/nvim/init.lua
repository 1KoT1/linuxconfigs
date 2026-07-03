
-- Я использую группу, чтобы избежать дублирования автокоманд при повторной загрузке файла
-- конфигурации. Достаточно одной группы на весь файл. Очищаю её в начале.
local g = vim.api.nvim_create_augroup("FileInitLua", { clear = true })



-- =============================================================================
-- 🛠  Лидер-клавиша (должна быть объявлена ПЕРВОЙ)
-- =============================================================================
vim.g.mapleader = ","

-- =============================================================================
-- 🛠  Базовые настройки (Опции / set)
-- =============================================================================
local opt = vim.opt

-- Нумерация строк
opt.number = true
opt.relativenumber = true

-- Открывать новые окна справа и снизу
opt.splitbelow = true
opt.splitright = true

-- Отступы
opt.tabstop = 2
opt.shiftwidth = 2

-- Системный буфер обмена
opt.clipboard = "unnamedplus" -- set clipboard=unnamedplus

-- Переключать язык в режиме ВСТАВКА независимо от системы. Таким образом я смогу писать
-- текст на русском, при этом клавиши управления останутся английскими.
-- <C-6> переключить язык
vim.opt.keymap = "russian-jcukenwin"
-- Режим ввода при старте (0 — английский, 1 — русский)
opt.iminsert=0
-- Режим поиска при старте (0 — английский, 1 — русский)
opt.imsearch=0

-- Подключать .vimrc из каталога в которм запущен vim.
-- secure для защиты, т.к. vim будет подключать .vimrc из любой директории, из
-- которой вы его запустите.
opt.exrc = true
opt.secure = true

-- Автодполнение команд
opt.wildmode='longest:full,full'

vim.keymap.set('n', '<Leader>f', ':AsyncRun git grep -n ', { desc = 'Find by git grep' })

-- =============================================================================
-- 🛠  Автодополнение
-- =============================================================================
opt.autocomplete = true
-- o (Omni-completion / LSP), . (Текущий буфер), w (Другие окна), b (Другие буферы), u (Выгруженные буферы), kspell (use the currently active spell checking)
opt.complete = "o,.,w,b,u,kspell"
opt.completeopt = "fuzzy,menuone,noselect,popup,nosort"

function get_char_before_cursor()
  local col_before = vim.fn.col('.') - 1
  local line = vim.fn.getline('.')
  return line:sub(col_before, col_before)
end

-- Перебор вариантов с помощью Tab и Shift+Tab
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, remap = true })
vim.keymap.set('i', '<Tab>', function()
  -- 1. Если меню автодополнения уже открыто, просто переходим к следующему элементу
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  end

  -- 2. Если перед курсором символы начала пути: '/', '.', '~' или '\' (для Windows)
  if get_char_before_cursor():match('[/%..~%\\]') then
    -- Симулируем нажатие Ctrl+X затем Ctrl+F для вызова встроенного дополнения путей
    return '<C-x><C-f>'
  end

  -- 3. Если если меню не открыто и перед курсором не начало пути, то возвращаем обычный Tab
	return '<Tab>'
end, { expr = true, remap = true })

-- В обратную сторону по Shift+Tab
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, remap = true })

-- Для автодополнения путей переходим на следующий уровень по нажатию /
vim.keymap.set('i', '/', function()
	-- Только если меню автодополнения уже открыто
	if vim.fn.pumvisible() == 1 then
		-- Если перед курсором символы разделителя пути: '/' или '\' (для Windows)
		if get_char_before_cursor():match('[/\\]') then
			-- Симулируем нажатие Ctrl+X затем Ctrl+F для вызова встроенного дополнения путей
			return '<C-x><C-f>'
		end
	end
  -- Если если меню не открыто, то возвращаем обычный /
	return '/'
end, { expr = true, remap = true })


-- =============================================================================
-- 🛠  C/C++
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp" },
	group = g,
	callback = function()
		-- Отступы
		vim.opt_local.cindent = true
		vim.opt_local.cinoptions = ">s,:0,l1,g0,(0,Ws"
	end,
})


-- =============================================================================
-- 🛠  Цветовые схемы и подсветка (Highlight)
-- =============================================================================
local hi = vim.api.nvim_set_hl

-- Прозрачный фон
hi(0, "Normal", { bg = "none" })
hi(0, "NormalFloat", { bg = "none" })

-- Диффы (vimdiff)
hi(0, "DiffAdd", { ctermbg = 22 })
hi(0, "DiffChange", { ctermbg = 22 })
hi(0, "DiffDelete", { ctermbg = 22 })
hi(0, "DiffText", { ctermbg = 52 })

-- Подсветка орфографии (Spell) с поддержкой подчёркивания волной (undercurl)
hi(0, 'SpellBad', { undercurl = true, sp = 'Red' })
hi(0, 'SpellCap', { undercurl = true, sp = 'Blue' })
hi(0, 'SpellRare', { undercurl = true, sp = 'Magenta' })
hi(0, 'SpellLocal', { undercurl = true, sp = 'Cyan' })

-- Автодполнение команд
vim.api.nvim_set_hl(0, "Pmenu", { bg = 'none' })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = '#96f3ff', bold = true })



-- =============================================================================
-- 🛠  Проверка орфографии
-- =============================================================================

local enable_spell_local = function()
	vim.opt_local.spell = true
	vim.opt_local.spelllang = { "ru_yo", "en_us" }
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "c", "cpp", "cmake", "gitcomit" },
	group = g,
	callback = enable_spell_local,
})
-- Вкл/выкл проверку орфографии:
-- :set spell/spell!
-- :Spell/SpellNot
-- ]s - Следующее слово с ошибкой;
-- [s - Предыдущее слово с ошибкой;
-- ]S - (Обратите внимание на заглавную букву «S») — похоже на «] s», найти, но
-- останавливаться только на плохих словах, а не на редкие слова или слова для
-- другого региона.
-- [S - по аналогии с «[s», но поиск в обратном направлении.
-- z= - отобразить список замен;
-- zg - Добавить в словарь;
-- zw - Убрать из словаря;
-- zG - Игнорировать слово;

vim.api.nvim_create_user_command('Spell', enable_spell_local, { desc = 'Enable a spell local' })
vim.api.nvim_create_user_command(
	'SpellNot',
	function()
		vim.opt_local.spell = false
	end,
	{ desc = 'Disable a spell local' }
)

-- =============================================================================
-- 🛠  Плагины
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Установка плагинов
require("lazy").setup(
	{
		'skywind3000/asyncrun.vim',
		'voldikss/vim-translator',
		{
			'Civitasv/cmake-tools.nvim',
			opts = {
				cmake_build_directory = "../build/${variant:buildType}"
			},
			lazy = true,
			dependencies = { 'nvim-lua/plenary.nvim' }
		}
		-- '1KoT1/go_to_file',
	}, {
		performance = {
			rtp = {
				reset = false, -- Запрещаем lazy.nvim ломать системные пути Ubuntu
			},
		},
		ui = {
			border = "rounded",
		},
	}
)

-- AsyncRun
vim.keymap.set('n', '<Leader>r', ':AsyncRun ', { desc = 'Async run' })
-- automatically open quickfix window when AsyncRun command is executed
-- set the quickfix window 20 lines height.
vim.g.asyncrun_open = 20

-- Translator
vim.g.translator_target_lang = 'ru'
vim.g.translator_default_engines = {'google'}
-- Display translation in a window
vim.keymap.set('n', '<Leader>t', '<Plug>TranslateW', { silent = true })
vim.keymap.set('v', '<Leader>t',  '<Plug>TranslateWV', { silent = true })

-- GoToFile
-- vim.keymap.set('n', '<leader>gf', ':GoToFile<CR>', { silent = true, desc = 'Открыть файл под курсором в другом но уже открытом окне' })

-- =============================================================================
-- 🛠  Markdown
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = g,
	callback = function()
		vim.api.nvim_buf_create_user_command(0, "Preview", function()
			-- Получаем полный путь к текущему файлу (%)
			local file = vim.fn.expand("%")

			-- Открываем вертикальный сплит
			vim.cmd("vsplit")

			-- Запускаем терминал с вашей командой entr + glow
			vim.fn.termopen('glow --tui '..file, {
				-- Автоматически закрывает окно при завершении (аналог ++close)
				on_exit = function()
					vim.cmd("bdelete!")
				end
			})
			vim.cmd("startinsert")
		end, {})
	end,
})

