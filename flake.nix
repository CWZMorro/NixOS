{
 description = "NixOS Flake";
 inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  niri.url = "github:sodiboo/niri-flake";
 };
 outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: {
  nixosConfigurations = {
   CielNixAzure = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
     ./hosts/local/configuration.nix
     home-manager.nixosModules.home-manager
     {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.cielnixazure = import ./home/cielnixazure/home.nix;
     } 
    ];
   };
  };
 };
}
