# bind9-centos7
This is a helm chart for bind9 deployment based on bind9-centos7-image.

## Description
This helm chart was considered to deploy the `named` container for various domain names on different sites. The concept is started from that separating the network by 2 different networks as management network and service network, and operating workers(nodes) site-by-site on a Cluster. It means that cluster network by CNIs are using only for management of cluster and all application service will use additional network such as SR-IOV and macvlan created by Multus.

+ Management Network: The network which was CNI plugin installed such as calico, flanel and openshift-sdn on openshift and okd cluster. It means that applications will not used ingress or egress by CNI plugins.
+ Service Network: The network for application services which is using IP based service, and it created with additional physical network interface by Multus.

Network environment will be different on each site and DNS server will not provided in some sites. It this case, to provide services with domain name, a separate DNS server is required. For this purpose, `bind9-centos7` helm chart was made with the intention of using a container rather than using a physical server or VM.

## Configuration
Additional Network by Multus is not contained on Chart. Because on helm, Network-attachment-definition object is not recognized as resource. So that Network-attachment-definition would be created after deployment, and deployment was not deployed because of no network-attachment-definition resource. (If I am wrong, please comment for it.)

A client pod is included for test the DNS queries. It can be enabled when install this chart with `--set` option.

For now, it can be installed only for 2 different sites `test` and `pangyo`, but additional sites can be configured with modification of chart.

## Installation
Before installation, there is prerequested things.
+ Please move the configuration files by each site's directory.
  + `/etc/named.conf` and `/etc/named.rfc1912.zones` files should saved on `named-etc/[SITE_NAME]/` directory.
  + Zone and reverse file should be saved on `named-var/[SITE_NAME]/` directory.
+ Add label on each workers(nodes) to recognize the site.
  + For 'test' site: `oc labels node worker01 location-node=test`
  + For 'pangyo' site: `oc labels node worker02 location-node=pangyo`

To install the chart,
```
$ helm install [RELEASE_NAME] [DIRECTORY_PATH_OF_CHART] --set workerLocation=[SITE_NAME],clientPod.enabled=true
```

If you do not want to install client pod for test, you can just ignore from `--set` option.

Installtion Example:
```
>> For "test" sites with client pod
$ helm install bind9-test . --set workerLocation=test,clientPod.enabled=true

>> For "pangyo" sites without client pod
$ helm install bind9-pangyo . --set workerLocation=pangyo
```

