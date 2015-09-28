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

function get_server_from_upstream(tbl)
    local us_table = {}
    for _, srv in ipairs(tbl) do
        us_table[srv["addr"]] = srv["weight"]
    end

end

for _, u in ipairs(us) do
    local srvs, err = get_servers(u)
    local us_table = {}
    if not srvs then
        ngx.say("failed to get servers in upstream ", u)
    else
        for _, srv in ipairs(srvs) do
            us_table[srv["addr"]] = srv["weight"]
        end
    end
    local server = random_weight(us_table)
    ngx.redirect("http://".. server, 301)
end
