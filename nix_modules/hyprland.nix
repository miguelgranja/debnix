{ pkgs, inputs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig = builtins.readFile ../hypr/hyprland.conf;
  };
}
