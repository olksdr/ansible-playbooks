## A simple ansible playbook for Elasticsearch/Logstash/Redis deployment
----------------------------------------------------------------------

Dependencies:
* was initially written for RedHat
* JDK should be installed (7 or 8)
* $JAVA_HOME should be set


In order to use this playbook all the hostnames and IPs should be changed accordingly (in *hosts* file or in any file that is located in vars/ folder)

To deploy ES/Redis on development env use the next command:

```
ansible-playbook -i hosts provisioning_logserver_es.yml --limit logserver_es_dev
```

on productoin env:

``` 
ansible-playbook -i hosts provisioning_logserver_es.yml --limit logserver_es_prod
```


For indexer deployment, accordingly *dev* can be change to *prod*:

```
ansible-playbook -i hosts provisioning_logserver_indexer.yml --limit logserver_indexer_dev
```


And finally to deploy logstash agents, use following command:

```
ansible-playbook -i hosts provisioning_logstash_clients.yml --limit logstash_dev
```


Suggestions and pul request are welcomed.
