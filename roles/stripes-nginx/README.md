# stripes-nginx

Ansible role to serve a stripes webpack with nginx (and optionally proxy Okapi).

## Notes

* If proxying Okapi, `stripes_okapi_url` for the `stripes-build` role must be set to this server (`http[s]://server_name[:listen_port]/okapi`).

## Prerequisites

* Roles:
  * stripes-build (to create the webpack)

## Variables

```yaml
# defaults
listen_port: 80
stripes_server_name: "{{ ansible_default_ipv4.address }}"
nginx_proxy_okapi: no
nginx_proxy_okapi_url: "http://{{ ansible_default_ipv4.address }}:9130"
```

## TODO

* Add option for configuring https
