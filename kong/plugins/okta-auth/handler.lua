local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.okta-auth.access"
local responses = require "kong.tools.responses"
local request = ngx.req

local OktaAuth = BasePlugin:extend()

OktaAuth.PRIORITY = 1000

function OktaAuth:new()
  OktaAuth.super.new(self, "okta-auth")
end

function OktaAuth:access(conf)
  OktaAuth.super.access(self)

  authorized, token_data = access.execute(request, conf)
  if not authorized then return responses.send_HTTP_UNAUTHORIZED() end

  for key, value in pairs(token_data) do
    request.set_header("OKTA-"..key, value)
  end
end

return OktaAuth
