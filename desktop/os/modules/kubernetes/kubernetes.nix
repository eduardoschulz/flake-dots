{pkgs, ...}:

{
  services.etcd = {
    enable = true;
    name = "core";
    listenClientUrls = [ "http://0.0.0.0:2379" ];
    advertiseClientUrls = [ "http://core:2379" ];
    listenPeerUrls = [ "http://0.0.0.0:2380" ];
    initialAdvertisePeerUrls = [ "http://core:2380" ];
    initialCluster = [
        "core=http://core:2380"
        "nixserver=http://nixserver:2380"
    ];
    initialClusterState = "new";
    initialClusterToken = "etcd-cluster";
  };
  

  services.kubernetes = {
    roles = [ "node" ];
    masterAddress = "192.168.0.129";
    kubelet.kubeconfig.server = "https://192.168.0.129:6443";
    apiserverAddress = "https://192.168.0.129:6443";
    easyCerts = false;
    kubelet.extraOpts = "--fail-swap-on=false";
    addons.dns.enable = true;
  };
}
