# nginx_redirect_balancer"

An attempt to implement redirector inside nginx which works similar to [py-balancer](https://github.com/whatvn/py-balancer)



# Usage

1. Install nginx with lua-nginx-module and lua-upstream-module 

2. Config your nginx likes this:


``` bash
 upstream google {
        server 192.168.10.226 weight=5;
        server 192.168.10.225 weight=1;
 } 

 ...
 ...

  server {
        listen       80;
        server_name  localhost;
	location / {
            content_by_lua_file path/to/redirect.lua;
        }

  } 
```

That's it. 
When pointing your browser to http://localhost/ , you will be redirect to http://192.168.10.226 or http://192.168.10.225 based on weight configured in upstream block. 

Status: only work with one upstream and location block  

