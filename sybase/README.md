## This is automated deploment playbook for full sybase setup
--------------------------------------------------------------

To provision the SYBASE on the remote host, use the command below hosts file should be changed/edited properly before run:

```
ansible-playbook -i hosts sybase_provisioning.yml
```

All the settings/IPs should be provided/enhanced before accordingly to the network setup.

The license file(s) can be copied later or the *response.txt* file could be modified to include it and apply the settings during installation process.


