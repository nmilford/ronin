ronin
=====

Ronin is a tool to enable masterless configuration management.

It is built to use [Chef](https://github.com/opscode/chef) or [Puppet](https://github.com/puppetlabs/puppet) as it's configuration interpretor.

### How it works

Ronin can source its runlist from a local YAML file or from an [etcd](https://github.com/coreos/etcd) cluster.  It can also grab it's configuration from a etcd cluster as well in lieu of it's local config file.

When using etcd, you can also specify multiple keys to grab in an order lowest precedence to highest.  This enables you to pull a 'common' configuration with other, per node, overrides.

Ronin uses [Git](https://github.com/git/git) to grab configuration management artifacts (Chef Cookbooks or Puppet Modules) and cache them locally. You can also specify that it pulls different branch of an artifact's git repository to isolate testing.

Once cached, Ronin will run your chosen interpretor over the artifacts.  By default it will on run the interpretor if git pulls any changes.

