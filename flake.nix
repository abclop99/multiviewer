{
  description = "Unofficial desktop client for F1 TV";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
