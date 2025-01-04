{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    github-nix-ci = {
      url = "github:juspay/github-nix-ci";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      github-nix-ci,
      ...
    }:
    let
      # forEachSystem = nixpkgs.lib.genAttrs [
      #   "aarch64-darwin"
      #   "aarch64-linux"
      # ];

      secrets =
        let
          inherit (builtins) fromJSON readFile;
        in
        with nixpkgs.lib;
        genAttrs [
          "cachix"
          "cloudflare"
          "github"
          "misc"
        ] (secretFile: fromJSON (readFile .secrets/${secretFile}.json));
    in
    {
      nixosConfigurations.oc-runner = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        pkgs = import nixpkgs { inherit system; };

        specialArgs = {
          inherit secrets;
        };

        modules = [
          ./configuration.nix
          disko.nixosModules.default
          github-nix-ci.nixosModules.default
        ];
      };

      #   apps = forEachSystem (
      #     system:
      #     let
      #       pkgs = import nixpkgs { inherit system; };
      #       inherit (pkgs) lib writeShellApplication;

      #       deploySystem = writeShellApplication {
      #         name = "deploy";
      #         runtimeInputs = [ pkgsCross.nixos-rebuild ];
      #         text = ''
      #           nixos-rebuild switch --show-trace \
      #             --target-host "root@oc-runner" \
      #             --build-host "localhost" \
      #             --flake .#oc-runner
      #         '';
      #       };
      #     in
      #     rec {
      #       default = deploy;

      #       deploy = {
      #         type = "app";
      #         program = lib.getExe deploySystem;
      #       };
      #     }
      #   );
    };
}
