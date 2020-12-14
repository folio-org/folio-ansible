# stripes-nginx

Ansible role to serve a stripes webpack with nginx (and optionally proxy Okapi).

## Notes

* If proxying Okapi, `stripes_okapi_url` for the `stripes-build` role must be set to this server (`http[s]://server_name[:listen_port]/okapi`).
* If proxying, nginx must be configured to handle large data imports. This can be set with nginx_proxy_upload_max_size
* to enable https, you have to enable proxying and provide the path to the certificate and key files

## Prerequisites

* Roles:
  * stripes-build (to create the webpack)

## Variables

```yaml
# defaults
stripes_listen_port: 80
stripes_enable_https: false
stripes_certificate_file: null
stripes_certificate_key_file: null
stripes_server_name:
  - "{{ ansible_default_ipv4.address }}"
nginx_proxy_okapi: no
nginx_proxy_okapi_url: "http://{{ ansible_default_ipv4.address }}:9130"
nginx_proxy_upload_max_size: 100M
```

## TODO

* Add option for configuring https
