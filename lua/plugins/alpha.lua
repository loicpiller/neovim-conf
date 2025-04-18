return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	enabled = true,
	init = false,
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local logo = [[
NNNNNNNN        NNNNNNNN                                  VVVVVVVV           VVVVVVVV iiii                          
N:::::::N       N::::::N                                  V::::::V           V::::::Vi::::i                         
N::::::::N      N::::::N                                  V::::::V           V::::::V iiii                          
N:::::::::N     N::::::N                                  V::::::V           V::::::V                               
N::::::::::N    N::::::N    eeeeeeeeeeee       ooooooooooo V:::::V           V:::::Viiiiiii    mmmmmmm    mmmmmmm   
N:::::::::::N   N::::::N  ee::::::::::::ee   oo:::::::::::ooV:::::V         V:::::V i:::::i  mm:::::::m  m:::::::mm 
N:::::::N::::N  N::::::N e::::::eeeee:::::eeo:::::::::::::::oV:::::V       V:::::V   i::::i m::::::::::mm::::::::::m
N::::::N N::::N N::::::Ne::::::e     e:::::eo:::::ooooo:::::o V:::::V     V:::::V    i::::i m::::::::::::::::::::::m
N::::::N  N::::N:::::::Ne:::::::eeeee::::::eo::::o     o::::o  V:::::V   V:::::V     i::::i m:::::mmm::::::mmm:::::m
N::::::N   N:::::::::::Ne:::::::::::::::::e o::::o     o::::o   V:::::V V:::::V      i::::i m::::m   m::::m   m::::m
N::::::N    N::::::::::Ne::::::eeeeeeeeeee  o::::o     o::::o    V:::::V:::::V       i::::i m::::m   m::::m   m::::m
N::::::N     N:::::::::Ne:::::::e           o::::o     o::::o     V:::::::::V        i::::i m::::m   m::::m   m::::m
N::::::N      N::::::::Ne::::::::e          o:::::ooooo:::::o      V:::::::V        i::::::im::::m   m::::m   m::::m
N::::::N       N:::::::N e::::::::eeeeeeee  o:::::::::::::::o       V:::::V         i::::::im::::m   m::::m   m::::m
N::::::N        N::::::N  ee:::::::::::::e   oo:::::::::::oo         V:::V          i::::::im::::m   m::::m   m::::m
NNNNNNNN         NNNNNNN    eeeeeeeeeeeeee     ooooooooooo            VVV           iiiiiiiimmmmmm   mmmmmm   mmmmmm
    ]]

		dashboard.section.header.val = vim.split(logo, "\n")
		local builtin = require("telescope.builtin")
		dashboard.section.buttons.val = {
			dashboard.button("f", " " .. " Find file", builtin.find_files),
			dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
			dashboard.button("r", " " .. " Recent files", builtin.oldfiles),
			dashboard.button("g", " " .. " Find text", builtin.live_grep),
			dashboard.button("l", " " .. " Lazy", "<cmd> Lazy <cr>"),
			dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			once = true,
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = "⚡ Neovim loaded "
					.. stats.loaded
					.. "/"
					.. stats.count
					.. " plugins in "
					.. ms
					.. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
