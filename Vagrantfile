# spin up 3 VMs - 1 core and 2 worker nodes - to setup k8s cluster

#to ensure the master is up first - no point of having Worker node up before Core
ENV['VAGRANT_NO_PARALLEL'] = 'yes'


Vagrant.configure(2) do |config|

  # shell script to configure (hostnames / firewal rules...) and install requirement kube{let,adm,ctl}
  config.vm.provision "shell", path: "_provision.sh"

  # Kubernetes Core (master) Node
  config.vm.define "k8score" do |k8score|
    k8score.vm.box = "centos/7"
    k8score.vm.hostname = "k8score.lab.local"
    k8score.vm.network "private_network", ip: "172.25.0.10"

    k8score.vm.provider "virtualbox" do |v|
      v.name = "k8s-Core"
      v.memory = 2048
      v.cpus = 2
    end
    
    #setup network and initialize cluster
    k8score.vm.provision "shell", path: "_k8s_core.sh"
  
  end

  NodeNb = 2

  # Kubernetes Worker Nodes
  (1..NodeNb).each do |i|
    config.vm.define "k8sworker#{i}" do |k8sworker|
      k8sworker.vm.box = "centos/7"
      k8sworker.vm.hostname = "k8sworker#{i}.lab.local"
      k8sworker.vm.network "private_network", ip: "172.25.0.1#{i}"

      k8sworker.vm.provider "virtualbox" do |v|
        v.name = "k8s-Worker#{i}"
        v.memory = 2048
        v.cpus = 2
      end
      
      #join the cluster
      k8sworker.vm.provision "shell", path: "_k8s_worker.sh"
    
    end
  end


end
