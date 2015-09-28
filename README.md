# nginx_redirect_balancer"

An attempt to implement redirector inside nginx which works similar to [py-balancer](https://github.com/whatvn/py-balancer)



# Usage

1. Install nginx with lua-nginx-module and lua-upstream-module, and ngx_devel_kit  

``` bash
	./configure --with-ld-opt=-Wl,-rpath,/usr/local/lib --add-module=lua-nginx-module --add-module=lua-upstream-nginx-module --add-module=ngx_devel_kit
```

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
	    # "google" is the name of your upstream configuration.
	    set $upstream "google"
            set_by_lua_file $res path/to/redirector.lua $upstream;
	    return 302 $res
        }

  } 
```

That's it. 
When pointing your browser to http://localhost/ , you will be redirect to http://192.168.10.226 or http://192.168.10.225 based on weight configured in upstream block. 

Status: work with upstream using IP address. Nginx does resolve upstream nginx domain name to its IP address, so this method will not work. 

