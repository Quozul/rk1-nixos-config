{
  config,
  pkgs,
  ...
}: {
    networking.firewall.allowedTCPPorts = [
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
        # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
        10250
        9100 # for prometheus node exporter
    ];
    networking.firewall.allowedUDPPorts = [
        8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];

    services.k3s = {
        enable = true;
        role = "agent";
        token = "Kjtf4pa*BWj(!=(s";
        serverAddr = "https://192.168.3.101:6443";
    };

    # For Longhorn support
    environment.systemPackages = [ pkgs.nfs-utils ];
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };

    # https://takingnotes.net/kubernetes/longhorn/
    system.activationScripts.usrlocalbin = ''
        mkdir -m 0755 -p /usr/local
        ln -nsf /run/current-system/sw/bin /usr/local/
    '';
}
