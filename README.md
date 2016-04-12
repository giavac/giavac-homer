giavac-homer

This is a Puppet module to install and configure Homer (https://github.com/sipcapture/homer)

Define a structure like this:

```
/root/homer-ui  (source code for homer-ui)
/root/homer-api (source code for homer-api)
/root/puppet/site.pp
```

Then:

```
cd /root/puppet
```

Depending on your strategy (hieradata, role/profile, etc) things may change, but you can just define the puppet/site.pp like:

```
node default {
    class { 'homer':
        manage_mysql        => true,
        mysql_password      => 'astrongone',
        mysql_root_password => 'averystrongone',
        ui_admin_password   => 'theadmin123',
    }
}
```

and apply:

```
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff
```

Dependencies
------------

- 'puppetlabs-stdlib'
- 'puppetlabs-mysql'
- 'puppetlabs-apt'

(see Modulefile)

Tested on
---------

Ubuntu 14.04
Debian 8.3

License
-------

GPLv2

Contact
-------

giacomo.vacca@gmail.com


Support
-------

Please log tickets and issues at our [Projects site](https://github.com/giavac/giavac-homer)
