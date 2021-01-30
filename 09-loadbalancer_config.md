```
stream {
    upstream kubernetes {
        server master1.mylap.in:6443;
        server master2.mylap.in:6443;
    }
    server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}
```