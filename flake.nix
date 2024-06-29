{
  description = "Unofficial desktop client for F1 TV®";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: {

    packages.x86_64-linux = {
      multiviewer = (import ./default.nix) {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      default = self.packages.x86_64-linux.multiviewer;
    };

  };
}
