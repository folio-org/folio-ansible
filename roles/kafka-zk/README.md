# kafka-zk
Installs kafka and zookeeper for single server setups. Uses docker-compose to configure a stack in /opt/kafka-zk.

## Defaults
```
kafka_port: 9092
kafka_host: "{{ ansible_default_ipv4.address }}"
zk_port: 2181
zk_host: "{{ ansible_default_ipv4.address }}"
```
