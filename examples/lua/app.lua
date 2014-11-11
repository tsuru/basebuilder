local lapis = require("lapis")
local app = lapis.Application()

app:get("/", function()
  return "Hello world from tsuru"
end)

return app
