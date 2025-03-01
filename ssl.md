# SSL证书问题

在使用Watt Toolkit时，经常会遇到各种证书问题

## npm
```bash
# 不严格检查SSL
npm config set strict-ssl false
```

## wget
```
# 临时参数
--no-check-certificate
```
```
# 配置文件
# ~/.wgetrc
check-certificate=off
```

## curl
```
--insecure
```
配置文件
```
# ~/.curlrc
insecure
```



