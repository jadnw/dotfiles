local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local _utils = {}

_utils.dpi = dpi

_utils.trim = function(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

_utils.split = function(str, sep)
  str = _utils.trim(str)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for item in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, item)
  end
  return t
end

_utils.replace = function(str, sub, rep)
  return string.gsub(str, sub, rep)
end

_utils.reverse = function(t)
  if #t <= 1 then
    return t
  end
  local _t = {}
  for i = 1, #t, 1 do
    _t[#t - i + 1] = t[i]
  end
  return _t
end

_utils.get_n_app = function(app_name)
  local app = { icon = nil, color = nil }
  local app_k = string.lower(app_name)
  if _G.configs.notifications.apps[app_k] then
    app = _G.configs.notifications.apps[app_k]
  end

  return app
end

return _utils
