# Linux DoQ

安装 dnsproxy
配置 dnsproxy 和 dnsmasq

# 支持 TLSv1.3 的 DoH

## 注释
| 名称                | 过滤 | DNSSEC | ECS |
| ------------------- | ---- | ------ | --- |
| Quad 9 Secure       | o    | o      | x   |
| Quad 9 Secure w/ECS | o    | o      | o   |
| Quad 9 Insecure     | x    | x      | x   |




| 名称                | ip                          | tls_auth_name        |
| ------------------- | --------------------------- | -------------------- |
| Quad 9 Secure       | `9.9.9.9`,`149.112.112.112` | `dns.quad9.net`      |
| Quad 9 Secure w/ECS | `9.9.9.11`,`149.112.112.11` | `dns11.quad9.net`    |
| Quad 9 Insecure     | `9.9.9.10`,`149.112.112.10` | `dns10.quad9.net`    |
| Cloudflare          | `1.1.1.1`,`1.0.0.1`         | `cloudflare-dns.com` |
| Google              | `8.8.8.8`,`8.8.4.4`         | `dns.google`         |
