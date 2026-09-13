vim.g.rails_projections = {
  [".env"] = { alternate = ".env.example" },
  [".env.example"] = { alternate = ".env" },
}

-- Open an alternate file and create it if it doesn't exist
local alternate_file_create_command = function(name, action)
  vim.api.nvim_create_user_command(name, function()
    vim.cmd(("execute '%s ' . rails#buffer().alternate()"):format(action))
  end, {})
end

alternate_file_create_command("AC", "e")
alternate_file_create_command("ACV", "vsp")
alternate_file_create_command("ACS", "sp")
