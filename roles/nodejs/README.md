# nodejs

Install [Node.js](https://nodejs.org/en), [npm](https://www.npmjs.com/), and [n](https://www.npmjs.com/package/n). Set the Node.js version using `n` for the root user.

## Usage

Invoke this role to install and configure for any host that requires it. For example:

```yaml
- hosts: my-folio-test
  roles:
    - role: nodejs
      nodejs_version: v16
```

## Variables

```yaml
---
# defaults
folio_install_type: single_server
nodejs_version: lts
```
