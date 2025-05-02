{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.seatfiller;
in
with lib;
{
  options.services.seatfiller = {
    enable = mkEnableOption "A service that uses cpu and memory so Oracle can't reclaim a VM instance.";
  };

  config = mkIf cfg.enable {
    systemd.services = {
      memory-stress = {
        description = "memory-stress";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${getExe pkgs.stress-ng} --vm 1 --vm-bytes 15% --vm-hang 0";
          Restart = "always";
          Type = "exec";
        };
      };

      cpu-stress = {
        description = "cpu-stress";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${getExe pkgs.stress-ng} --cpu 8 --cpu-load 15";
          Restart = "always";
          Type = "exec";
        };
      };
    };
  };
}
