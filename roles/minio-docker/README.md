# minio-docker

Role to spin up a Docker container running [MinIO](https://min.io/), which can be used by mod-data-export-worker. Docker image is configurable, defaults to [minio/minio](https://hub.docker.com/r/minio/minio).

Required for FOLIO single-server environments without access to S3.

This role depends on the [docker-engine](../docker-engine) role, which is installed as a dependency.

## Variables

```yaml
---
# defaults
minio_image: minio/minio
minio_port: 9000
minio_data_path: /data # path to data directory, see below

# optional variables
# Local mounts. Can be combined with minio_data_path above to persist minio storage
# minio_volumes:
#   - "/usr/local/shared/minio-data:{{ minio_data_path }}"
# Buckets to create on initialization
# minio_buckets:
#   - "{{ lists_app_bucket_name | default('lists-app-bucket') }}"
```
