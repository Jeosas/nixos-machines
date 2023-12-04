--check install
-- local result_ok, _, _ = os.execute("command -v vscode-json-language-server &> /dev/null")
-- if not result_ok then
-- 	vim.notify(
-- 		"Couldn't install 'json' lsp.\nPlease install the folowing packages:\n - vscode-json-languageserver (lsp)",
-- 		"error"
-- 	)
-- end

-- lsp settings
local default_schemas = nil
local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
if status_ok then
	default_schemas = jsonls_settings.get_default_schemas()
end

-- https://schemastore.org
local schemas = {
	{
		dectription = "JSON schema for .pre-commit-config.yaml",
		fileMatch = {
			".pre-commit-config",
			".pre-commit-config.yaml",
		},
		url = "https://json.schemastore.org/pre-commit-config.json",
	},
	{
		dectription = "A JSON schema for GeoJSON files",
		fileMatch = {
			"*.geojson",
		},
		url = "https://geojson.org/schema/GeoJSON.json",
	},
	{
		dectription = "JSON schema for GitHub Workflow files",
		fileMatch = {
			".github/workflows/*.yml",
			".github/workflows/*.yaml",
		},
		url = "https://json.schemastore.org/github-workflow.json",
	},
	{
		dectription = "JSON schema for Python project metadata and configuration",
		fileMatch = {
			"pyproject.toml",
		},
		url = "https://json.schemastore.org/pyproject.json",
	},
	{
		dectription = "A schema for Cargo.toml.",
		fileMatch = {
			"carto.toml",
		},
		url = "https://json.schemastore.org/cargo.json",
	},
	{
		description = "Json schema for properties json file for a GitHub Workflow template",
		fileMatch = {
			".github/workflow-templates/**.properties.json",
		},
		url = "https://json.schemastore.org/github-workflow-template-properties.json",
	},
	{
		description = "Packer template JSON configuration",
		fileMatch = {
			"packer.json",
		},
		url = "https://json.schemastore.org/packer.json",
	},
	{
		description = "NPM configuration file",
		fileMatch = {
			"package.json",
		},
		url = "https://json.schemastore.org/package.json",
	},
}

local function extend(tab1, tab2)
	for _, value in ipairs(tab2 or {}) do
		table.insert(tab1, value)
	end
	return tab1
end

local extended_schemas = extend(schemas, default_schemas)

local opts = {
	settings = {
		json = {
			schemas = extended_schemas,
		},
	},
	setup = {
		commands = {
			Format = {
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
				end,
			},
		},
	},
}

return opts
