gvacca-homer

This is a Puppet module to install and configure Homer (https://github.com/sipcapture/homer)

Define a structure like this:
/root/homer-ui  (source code for homer-ui)
/root/homer-api (source code for homer-api)
/root/puppet/modules/homer (this module)

Then
cd /root/puppet

and apply:
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff --noop
sudo puppet apply --debug --modulepath=/etc/puppet/modules:modules/ site.pp --show_diff

Dependencies
------------

See Modulefile:
'puppetlabs/stdlib'
'puppetlabs/mysql'
'puppetlabs/apt'

Tested on
---------

Ubuntu 14.04
(expected to work on debian jessie)


License
-------

GPLv2

Contact
-------

giacomo.vacca@gmail.com


Support
-------

Please log tickets and issues at our [Projects site](https://github.com/giavac/gvacca-homer)
