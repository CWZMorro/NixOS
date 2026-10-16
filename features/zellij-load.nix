{ inputs, ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      packages.zellij-load = inputs.zellij-load.packages.${system}.default;
    };
}
