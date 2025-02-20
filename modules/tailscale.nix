{ config, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;

    authKeyFile = config.age.secrets.tailscale.path;
    authKeyParameters.preauthorized = true;

    extraUpFlags = [
      "--accept-dns=false"
      "--advertise-routes=10.0.0.0/24,169.254.169.254/32"
    ];
  };
}
