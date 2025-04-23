return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- Formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- ts/js formatter
				"stylua", -- lua formatter
				"eslint_d", -- ts/js linter
				"shfmt", -- Shell formatter
				"checkmake", -- linter for Makefiles
				"php-cs-fixer", -- PHP formatter
			},
			automatic_installation = true,
		})

		local Path = require("plenary.path")

		local function find_php_bin(binary)
			local search_dirs = { ".", "./WWW" }
			for _, dir in ipairs(search_dirs) do
				local path = Path:new(dir, "vendor", "bin", binary)
				if path:exists() then
					return path:absolute()
				end
			end
			return nil
		end

		local phpcs_path = find_php_bin("phpcs")
		local phpcbf_path = find_php_bin("phpcbf")

		-- Check if a phpcs config file exists in the project (.phpcs.xml or .phpcs.xml.dist)
		local has_phpcs_config = vim.fn.filereadable(".phpcs.xml") == 1 or vim.fn.filereadable(".phpcs.xml.dist") == 1

		-- Initialize the sources table
		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
		}

		-- Add phpcbf as a formatter if it's available, php-cs-fixer instead if not
		if phpcbf_path then
			table.insert(
				sources,
				formatting.phpcbf.with({
					command = phpcbf_path,
					extra_args = has_phpcs_config and {} or { "--standard=Symfony" },
				})
			)
		else
			table.insert(
				sources,
				formatting.phpcsfixer.with({
					command = "php-cs-fixer",
					args = {
						"fix",
						"--quiet",
						"--using-cache=no",
						"--no-interaction",
						"--stdin-path",
						"$FILENAME",
						"-",
					},
					to_stdin = true,
				})
			)
		end

		-- Add phpcs as a diagnostic source if it's available
		if phpcs_path then
			table.insert(
				sources,
				diagnostics.phpcs.with({
					command = phpcs_path,
					extra_args = has_phpcs_config and {} or { "--standard=Symfony" },
				})
			)
		end

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
