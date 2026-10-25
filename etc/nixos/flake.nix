{
  description = "BASE";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zapret-discord-youtube = {
      url = "github:kartavkun/zapret-discord-youtube";
    };

    driftwm = {
      url = "github:malbiruk/driftwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awg-tui = {
      url = "github:isnotacceptable/awg-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, zapret-discord-youtube, driftwm,
    awg-tui,
    ... 
  }@inputs:
  let
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "python-2.7.18.8"
        "electron-25.9.0"
      ];
    };

  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
	  {
            nixpkgs.config = config;
            nixpkgs.overlays = [
              (final: prev: {
                pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
                  (pythonFinal: pythonPrev: {
                    inline-snapshot = pythonPrev.inline-snapshot.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      checkPhase = "true";
                    });
		    django = pythonPrev.django.overridePythonAttrs (oldAttrs: {
                      doCheck = false;
                      checkPhase = "true";
                    });
		    httpcore2 = pythonPrev.httpcore2.overridePythonAttrs (oldAttrs: {
		      doCheck = false;
		      checkPhase = "true";
		    });
                  })
                ];
              })
            ];
          }

          driftwm.nixosModules.default
	  awg-tui.nixosModules.default
	  inputs.home-manager.nixosModules.default
	  {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
	      backupFileExtension = "backup";
              users.ina = import ./home/home.nix;

            };
	  }

          zapret-discord-youtube.nixosModules.default
          {
            services.zapret-discord-youtube = {
              enable = false;
              configName = "general(ALT3)";

            };
          }
        ];
      };
    };
  };
}
