# post config entries
Posts configuration entries to the `configurations/entries` endpoint for a tenant.

## Usage
Add a template and default variables for each configuration entry. Configurations follow the [schema](https://github.com/folio-org/mod-configuration/blob/master/ramls/_schemas/kv_configuration.schema). More information on configuration entries is available in the [mod-configuration](https://github.com/folio-org/mod-configuration) repository. The defaults show configurations for mod-email. List templates in the `config_entry_list` variable to have them posted to the `/configurations/entries` interface.

## Defaults
```
email_smtp_host: localhost
email_smtp_port: 587
email_from: noreply@localhost
email_username: "email_user"
email_password: "email_password"

config_entry_list:
  - email_from.json.j2
  - email_password.json.j2
  - email_smtp_host.json.j2
  - email_smtp_port.json.j2
  - email_username.json.j2

okapi_port: 9130
okapi_url: "http://{{ ansible_default_ipv4.address }}:{{ okapi_port }}"

tenant: diku
admin_user:
  username: diku_admin
  password: admin
```

In addition to the default config entries, when 'do_suppress_edit' is set to 'True' and a
list of users is defined in 'suppress_edit_userlist',  the list of users are configured so 
that they cannot be edited via the Stripes UI (@folio/users). 


