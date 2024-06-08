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
      hello = (import ./default.nix) {pkgs = nixpkgs.legacyPackages.x86_64-linux; };

      default = self.packages.x86_64-linux.hello;
    };

  };
}
