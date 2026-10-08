-- Clingo / ASP: filetype detection + syntax, in one place.
-- *.cl is deliberately absent: core detects it as OpenCL or Lisp by content.
return {
	"rkaminsk/clingo-syntax.nvim",
	ft = "clingo",
	init = function()
		vim.filetype.add({ extension = { lp = "clingo", asp = "clingo" } })
	end,
}
