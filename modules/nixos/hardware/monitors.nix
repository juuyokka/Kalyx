{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.kalyx.monitors;
in
{
  # Kalyx allows you to configure your monitors without limits, these monitor settings will apply on any DE/WM that Kalyx supports.
  # Finally! A standardized monitor system where I don't gotta mess with my configs every time I try a new WM.
  # These changes apply to home manager and nixos, meaning you can setup your TTY's to follow your monitor configuration automatically.
  # TODO: add automatic TTY adjustments.
  options.kalyx.monitors = { # TODO: Refactor to submodule
    monitors = mkOption {
      type = types.listOf types.attrs;
      default = [
	      # TIP: Monitor position is calculated with the scaled (and transformed) resolution. I.E. "1920x0" would place a 4k monitor with scale 2 left of your 1080p monitor. "1080x0" would rotate the monitor by 90 degrees as well.
        # TIP: "maxres" and "maxrr" will use your monitors maximum possible resolution and refresh rate, respectively. These options override "frame_rate". Additionally, you can use "default" to use the preffered monitor resolution.

        # TEMPLATE OPTIONS
        # {resolutizon="1920x1080"; framerate=60; position="0x0"; adapter="DP-1"; scale=1; transform=0; mirroring="DP-2";}
      ];
    };
    workspaces = {
      # not working yet...
      mouseBased = mkOption {
        type = types.bool;
	      default = true;
      };

      displayAssociation = mkOption {
        type = types.listOf types.attrs;
        default = [
          # TEMPLATE OPTIONS
          # {display="DP-1"; workspaces=[{number=1; default=true;} {number=2; default=false;} {number=3; default=false;}];}
        ];
      };
    };
    defaultMonitor = mkOption {
      type = types.attrs;
      # Same thing as monitors just without the adapter property
      default = {resolution="default"; scale=1;};
    };
  };

  config = {
    #=# KALYX DEPS #=#
    kalyx = { };
    #================#
    
    #=# GLOBAL HOME MANAGER #=#
    home-manager.sharedModules = [{
      kalyx.monitors.disableWarning = lib.mkDefault (cfg.monitors != []);
      # TODO: After monitors refactor to submodule, set Home Manager options. 
    }];
    #=========================#
  };
}
