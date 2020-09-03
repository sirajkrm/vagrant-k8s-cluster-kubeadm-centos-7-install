# vagrant-provision-K8S-cluster-on-centos-7

Vagrant file to create a Kubernetes Cluster on CentOS 7. <br />
1 Core node  <br />
2 Worker nodes  <br />
Kubernetes Version: 1.19.0  <br />
Docker CE Version: 19.03  <br />

all you need to to do:
have vagrant and virtualbox well installed
clone this repo
type: vagrant up
enjoy cup of coffee while cluster being ready

NOTES:

1- I used private network, 172.25.0.0/16 - feel free to change it <br />
I had an issue with public network conflicts <br />

2- I used weave net for this installation <br />
I read couple article being good and having feature same as Flannel and Calico <br/>
Weave net support encryption.. you may need some additional resources <br />

3- container restart <br />
you may see in one of the nodes some containers are restarting (weave net) <br />

otherwise.. <br />
you should be all set!
