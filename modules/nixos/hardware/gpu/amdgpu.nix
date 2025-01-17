{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.kalyx.amdgpu;
in
{
  options.kalyx.amdgpu = {
	  enable = mkEnableOption "amdgpu";
  };

  config = mkIf cfg.enable {
    kalyx.gpu.enable = true;

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
