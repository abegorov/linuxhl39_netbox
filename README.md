# Высокодоступный стенд NetBox, Ceph, Patroni, Redis, VictoriaMetrics, ElasticSearch, Kibana и Grafana

## Задание

Необходимо развернуть NetBox с кластеризацией и балансировкой веб-сервера и СУБД.

В итоге в проект должны быть включены:

- как минимум 2 узла с СУБД;
- минимум 2 узла с веб-серверами;
- центральный сервер сбора логов;
- мониторинг.

## Реализация

Задание сделано так, чтобы его можно было запустить как в **Vagrant**, так и в **Yandex Cloud**. После запуска происходит развёртывание следующих виртуальных машин:

- **netbox-core-01** - **ceph**, **etcd**, **redis sentinel**;
- **netbox-core-02** - **ceph**, **etcd**, **redis sentinel**;
- **netbox-core-03** - **ceph**, **etcd**, **redis sentinel**;
- **netbox-db-01** - **postgresql**, **redis**;
- **netbox-db-02** - **postgresql**, **redis**;
- **netbox-web-01** - **netbox**, **angie**, **keepalived**;
- **netbox-web-02** - **netbox**, **angie**, **keepalived**;
- **netbox-logs-01** - **elasticsearch**, **victoriametrics**, **alertmanager**;
- **netbox-logs-02** - **elasticsearch**, **victoriametrics**, **alertmanager**;
- **netbox-logs-03** - **elasticsearch**, **victoriametrics**, **alertmanager**;
- **netbox-ui-01** - **grafana**, **kibana**, **keepalived**;
- **netbox-ui-02** - **grafana**, **kibana**, **keepalived**.

В независимости от того, как созданы виртуальные машины, для их настройки запускается **Ansible Playbook** [provision.yml](provision.yml) который последовательно запускает следующие роли:

## Запуск

### Запуск в Yandex Cloud

1. Необходимо установить и настроить утилиту **yc** по инструкции [Начало работы с интерфейсом командной строки](https://yandex.cloud/ru/docs/cli/quickstart).
2. Необходимо установить **Terraform** по инструкции [Начало работы с Terraform](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart).
3. Необходимо установить **Ansible**.
4. Необходимо перейти в папку проекта и запустить скрипт [up.sh](up.sh).

### Запуск в Vagrant (VirtualBox)

Необходимо скачать **VagrantBox** для **bento/ubuntu-24.04** версии **202502.21.0** и добавить его в **Vagrant** под именем **bento/ubuntu-24.04/202502.21.0**. Сделать это можно командами:

```shell
curl -OL https://app.vagrantup.com/bento/boxes/ubuntu-24.04/versions/202502.21.0/providers/virtualbox/amd64/vagrant.box
vagrant box add vagrant.box --name "bento/ubuntu-24.04/202502.21.0"
rm vagrant.box
```

После этого нужно сделать **vagrant up** в папке проекта.

## Проверка

Протестировано в **OpenSUSE Tumbleweed**:

- **Vagrant 2.4.9**
- **VirtualBox 7.2.6_SUSE r172322**
- **Ansible 2.20.5**
- **Python 3.13.13**
- **Jinja2 3.1.6**
