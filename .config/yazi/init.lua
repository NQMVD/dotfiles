require("git"):setup()

require("full-border"):setup()

require("starship"):setup()

-- Header:children_add(function()
-- 	if ya.target_family() ~= "unix" then
-- 		return ui.Line {}
-- 	end
-- 	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
-- end, 500, Header.LEFT)