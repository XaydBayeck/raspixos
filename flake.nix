{
  description = "Raspberry Pi image for opencv develope";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware }:
    let
      lib = nixpkgs.lib;
    in
    rec {
      nixosConfigurations.rpi2 = lib.nixosSystem {
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          {
            nixpkgs.config.allowUnsupportedSystem = true;
            nixpkgs.hostPlatform.system = "armv7l-linux";
            nixpkgs.buildPlatform.system = "x86_64-linux";
            nixpkgs.config.allowUnfree = true;
          }
          ./configuration.nix
        ];
      };
      images.rpi2 = nixosConfigurations.rpi2.config.system.build.sdImage;
    };
}
