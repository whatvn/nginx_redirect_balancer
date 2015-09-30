local concat = table.concat
local upstream = require "ngx.upstream"
local get_servers = upstream.get_servers
local get_upstreams = upstream.get_upstreams
local random = math.random 
local us = get_upstreams()


function random_weight(tbl)
   local total = 0
   for k, v in pairs(tbl) do
       total = total + v
   end
   local offset = random(0, total - 1)
   for k1, v1 in pairs(tbl) do 
       if offset < v1 then
           return k1
       end
       offset = offset - v1
   end
end

for _, u in ipairs(us) do
    -- ngx.say("upstream ", u, ":")
    if u == ngx.arg[1] then
    	local srvs, err = get_servers(u)
    	local us_table = {}
    	if not srvs then
            ngx.say("failed to get servers in upstream ", u)
    	else
    	    for _, srv in ipairs(srvs) do
            	us_table[srv["name"]] = srv["weight"]
    	    end
    	end
    	local destination = random_weight(us_table)
    	--ngx.redirect("http://".. server..ngx.var.uri.."?"..ngx.var.args, 302)
    	if not ngx.var.args or ngx.var.args == '' then
    	    return "http://"..destination..ngx.var.uri
        end
	return "http://"..destination..ngx.var.uri.."?"..ngx.var.args
    end
end



