# Metadb
Provisions a Metadb database on the same DB instance as the FOLIO database.  Populates the
database with sample data. 

## Requirements
This role expects the postgres and docker-engine roles to have been previously executed. This 
role is inteded for single server type builds.

## Notes

* Set the `server_only` or `init_only` variable to perform one operation or the other.
