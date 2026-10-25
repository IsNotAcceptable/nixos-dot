{
  description = "Office Env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, craftapps }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
	inherit system;
	config.allowUnfree = true;
      };

      craftPkgs = craftapps.overlays.default pkgs pkgs;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with craftPkgs.craftapps; [
	  wordcraft
	  gridcraft
	  deckcraft
	  pdfcraft
        ];

        shellHook = ''
          export TMP_DIR=$(mktemp -d -p /tmp office-box.XXXXXX)
          export HOME="$TMP_DIR"
          export TMPDIR="$TMP_DIR"
	  
          echo "=== Office Env ==="
          echo "TMP_DIR (RAM): $TMP_DIR"

          trap 'rm -rf "$TMP_DIR"; echo "=== Env clear ==="' EXIT
        '';
      };
    };
}
