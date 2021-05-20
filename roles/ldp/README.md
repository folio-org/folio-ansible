# ldp
Provisions LDP. This sets up an LDP database in postgres, plus an LDP server running in a docker container. See the [LDP Admin Guide](https://github.com/library-data-platform/ldp/blob/master/doc/Admin_Guide.md) for more details. This role performs the database initialization and starts the LDP server software.

## Requirements
This role expects the postgres and docker-engine roles to have been previously executed. This role is inteded for single server type builds.

## Notes

* Set the `server_only` or `init_only` variable to perform one operation or the other.
* Use the `ldp_use_odbc` variable to configure LDP to use ODBC for older versions of LDP.
