# elasticsearch
This role provisions elasticsearch running as a container on a single server install.

Note that the default elasticsearch port 9200 is mapped to the host port 9301. This is because 9200 may be used by Okapi for a folio module. Change the `elasticsearch_host_rest_port` to update the host port elasticsearch should be mapped to.
