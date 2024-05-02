-- Open tree when in config dir
local configdir = vim.fn.system("echo $HOME/.config")
configdir = string.sub(configdir, 1, string.len(configdir) - 1)
if string.find(vim.fn.system("pwd"), configdir) ~= nil then
  vim.cmd("NvimTreeOpen")
  vim.cmd("NvimTmuxNavigateRight")
end
