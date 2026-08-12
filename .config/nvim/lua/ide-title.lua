local M = {}

local function started_with_diff()
  for _, arg in ipairs(vim.v.argv) do
    if arg == "-d" then
      return true
    end
  end
  return false
end

local function getOrDefault(opts, field, default)
  if type(opts) == "table" and type(opts[field]) == "string" then
    return opts[field]
  end
  return default
end

function M.setup(opts)
  vim.opt.title = true
  local title = getOrDefault(opts, "title", vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
  if started_with_diff() then
    vim.opt.titlestring = "🗐🗐 " .. title
  else
    vim.opt.titlestring = "++ " .. title
  end
end

return M
