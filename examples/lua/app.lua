local lapis = require("lapis")
local app = lapis.Application()

app:get("/", function()
  return "Hello Lua World!"
end)

return app
