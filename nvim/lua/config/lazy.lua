local lazy = require("lazy")
local nixCats = require("nixCats")

local lazyvim_spec = { "LazyVim/LazyVim", import = "lazyvim.plugins" }

if nixCats('general') then

  local allPlugins = require('nixCats').pawsible.allPlugins

  if allPlugins.LazyVim then
    lazyvim_spec.dir = allPlugins.LazyVim
    lazyvim_spec.name = "LazyVim"
  end
end

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    lazyvim_spec,
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    missing = false,
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = false, -- check for plugin updates periodically
  }, -- automatically check for plugin updates
  change_detection = {
    enabled = false,
    notify = false,
  },
  performance = {
    rtp = {
      reset = false,
    },
  },
})
