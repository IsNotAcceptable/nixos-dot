{
  description = "BASE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-soft.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
    
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    zapret-discord-youtube = {
      url = "github:kartavkun/zapret-discord-youtube";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixvim, zapret-discord-youtube, ... }@inputs:
  let
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "python-2.7.18.8"
        "electron-25.9.0"
      ];
    };

    pkgs = import nixpkgs {
      inherit system;
      inherit config;
    };
    soft = import inputs.nixpkgs-soft {
      inherit system;
      inherit config;
    };
    stable = import inputs.nixpkgs-stable {
      inherit system;
      inherit config;
    };
  in
  {
    nixosConfigurations = {
      empty = nixpkgs.lib.nixosSystem {
        specialArgs = { 
          inherit stable; 
          inherit soft; 
          inherit inputs;

          jetbrains-lib = inputs.nix-jetbrains-plugins.lib;
        };
        inherit pkgs;
        inherit system;

        modules = [
          ./configuration.nix

	  inputs.home-manager.nixosModules.default
	  {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs stable soft pkgs; };
              users.vibeman = import ./home/home.nix;

            };
	  }

          zapret-discord-youtube.nixosModules.default
          {
            services.zapret-discord-youtube = {
              enable = true;
              config = "general(ALT10)";

            };
          }
        ];
      };
    };
  };
}
