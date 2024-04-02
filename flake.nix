{
  description = "rtl_433 home assistant addon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ { 
    self,
    nixpkgs,
    flake-parts, 
    ... 
  }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        
      ];
      systems = [ "x86_64-linux" ];
      perSystem = { 
        config, 
        self', 
        inputs', 
        pkgs, 
        system, 
        lib, 
        ... 
      }: 
      let 
        rtl_433_img = (import ./docker_img.nix {inherit pkgs;});
      in
      {
        packages.default = rtl_433_img;
      };
    };
}