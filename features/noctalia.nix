{ inputs, ... }:

{
  perSystem =
    { pkgs, system, ... }:
    let
      patched-noctalia = inputs.noctalia.packages.${system}.default.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          find $out -type f -name "*.qml" -exec sed -i 's/Quickshell\.iconPath(\([^,)]*\))/Quickshell.iconPath(\1, true)/g' {} +
        '';
      });
    in
    {
      packages.morro-noctalia = patched-noctalia;
    };
}
