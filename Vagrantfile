# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['ANSIBLE_CALLBACK_RESULT_FORMAT'] = 'yaml'

PROJECT = PRJ = :netbox

DEFAULT_MACHINE = {
  :domain => 'internal',
  :box => 'bento/ubuntu-24.04/202510.26.0',
  :cpus => 1,
  :memory => 4096,
  :disks => {},
  :networks => {},
  :intnets => {},
  :forwarded_ports => [],
  :modifyvm => []
}

GROUPS = {
  :core => {
    :"#{PRJ}-core-01" => {
      :disks => { :disk1 => '10GB', },
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.11' }, },
      :forwarded_ports => [{
          :id => 'ceph-dashboard',
          :guest_ip => '  10.130.0.11', :guest => 8443,
          :host_ip  =>     '127.0.0.1', :host  => 8443,
        },
      ],
    },
    :"#{PRJ}-core-02" => {
      :disks => { :disk1 => '10GB', },
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.12' }, },
      :forwarded_ports => [{
          :id => 'ceph-dashboard',
          :guest_ip => '  10.130.0.11', :guest => 8443,
          :host_ip  =>     '127.0.0.1', :host  => 8444,
        },
      ],
    },
    :"#{PRJ}-core-03" => {
      :disks => { :disk1 => '10GB', },
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.13' }, },
      :forwarded_ports => [{
          :id => 'ceph-dashboard',
          :guest_ip => '  10.130.0.11', :guest => 8443,
          :host_ip  =>     '127.0.0.1', :host  => 8445,
        },
      ],
    },
  },
  :db => {
    :"#{PRJ}-db-01" => {
      :cpus => 2,
      :memory => 3072,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.21' }, },
    },
    :"#{PRJ}-db-02" => {
      :cpus => 2,
      :memory => 3072,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.22' }, },
    },
  },
  :web => {
    :"#{PRJ}-web-01" => {
      :memory => 2048,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.31' }, },
      :networks => { :private_network => { :ip => '192.168.56.31' } },
    },
    :"#{PRJ}-web-02" => {
      :memory => 2048,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.32' }, },
      :networks => { :private_network => { :ip => '192.168.56.32' } },
    },
  },
  :logs => {
    :"#{PRJ}-logs-01" => {
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.41' }, },
      :forwarded_ports => [{
          :id => 'alertmanager',
          :guest_ip => '  10.130.0.41', :guest => 9093,
          :host_ip  =>     '127.0.0.1', :host  => 9093,
        }, {
          :id => 'vmselect',
          :guest_ip => '  10.130.0.41', :guest => 8481,
          :host_ip  =>     '127.0.0.1', :host  => 8481,
        },
      ],
    },
    :"#{PRJ}-logs-02" => {
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.42' }, },
      :forwarded_ports => [{
          :id => 'alertmanager',
          :guest_ip => '  10.130.0.42', :guest => 9093,
          :host_ip  =>     '127.0.0.1', :host  => 9094,
        }, {
          :id => 'vmselect',
          :guest_ip => '  10.130.0.42', :guest => 8481,
          :host_ip  =>     '127.0.0.1', :host  => 8482,
        },
      ],
    },
    :"#{PRJ}-logs-03" => {
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.43' }, },
      :forwarded_ports => [{
          :id => 'alertmanager',
          :guest_ip => '  10.130.0.43', :guest => 9093,
          :host_ip  =>     '127.0.0.1', :host  => 9095,
        }, {
          :id => 'vmselect',
          :guest_ip => '  10.130.0.43', :guest => 8481,
          :host_ip  =>     '127.0.0.1', :host  => 8483,
        },
      ],
    },
  },
  :ui => {
    :"#{PRJ}-ui-01" => {
      :memory => 2048,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.51' }, },
      :forwarded_ports => [{
          :id => 'kibana',
          :guest_ip => '  10.130.0.51', :guest => 8443,
          :host_ip  =>     '127.0.0.1', :host  => 5601,
        },
      ],
    },
    :"#{PRJ}-ui-02" => {
      :memory => 2048,
      :intnets => { :"#{PRJ}" => { :ip => '10.130.0.52' }, },
      :forwarded_ports => [{
          :id => 'kibana',
          :guest_ip => '  10.130.0.52', :guest => 8443,
          :host_ip  =>     '127.0.0.1', :host  => 5602,
        },
      ],
    },
  },
}
MACHINES = GROUPS.values.each_with_object({}) { |m, o| o.merge!(m) }
ANSIBLE_GROUPS = GROUPS.to_h{ |k, v| [k, v.keys()] }
ANSIBLE_HOSTVARS = MACHINES.each_with_object({}) {
  |(name, config), obj| obj[name] = {
    'ip_address' => config.dig(:intnets, :"#{PRJ}", :ip),
    'ip_address_external' => config.dig(:networks, :private_network, :ip)
  }
}

def provisioned?(host_name)
  return File.exist?('.vagrant/machines/' + host_name.to_s +
    '/virtualbox/action_provision')
end

Vagrant.configure('2') do |config|
  MACHINES.each do |host_name, host_config|
    host_config = DEFAULT_MACHINE.merge(host_config)
    config.vm.define host_name do |host|
      host.vm.box = host_config[:box]
      if not provisioned?(host_name)
        host.vm.host_name = host_name.to_s + '.' + host_config[:domain].to_s
      end

      host.vm.provider :virtualbox do |vb|
        vb.cpus = host_config[:cpus]
        vb.memory = host_config[:memory]

        if !host_config[:modifyvm].empty?
          vb.customize ['modifyvm', :id] + host_config[:modifyvm]
        end
      end

      host_config[:disks].each do |name, size|
        host.vm.disk :disk, name: host_name.to_s + '-' + name.to_s, size: size
      end

      host_config[:intnets].each do |name, intnet|
        intnet[:virtualbox__intnet] = name.to_s
        host.vm.network(:private_network, **intnet)
      end
      host_config[:networks].each do |network_type, network_args|
        host.vm.network(network_type, **network_args)
      end
      host_config[:forwarded_ports].each do |forwarded_port|
        host.vm.network(:forwarded_port, **forwarded_port)
      end

      if MACHINES.keys.last == host_name
        host.vm.provision :ansible do |ansible|
          ansible.playbook = 'provision.yml'
          ansible.groups = ANSIBLE_GROUPS
          ansible.host_vars = ANSIBLE_HOSTVARS
          ansible.limit = 'all'
          ansible.compatibility_mode = '2.0'
          ansible.raw_arguments = ['--diff']
          # ansible.tags = ['lineinfile']
          # ansible.tags = ['kibana']
          # ansible.tags = ['tls_ca', 'tls_certs', 'kibana']
          # ansible.skip_tags = ['apt_upgrade']
        end
      end

      host.vm.synced_folder '.', '/vagrant', disabled: true
    end
  end
end
