{
	description = "Grayjay's JustCef library";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = {
		self,
		nixpkgs,
	}: let
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};

		getArch = system: nix2Net."${system}";
		nix2Net = {
			x86_64-linux = "linux-x64";
		};

		sourceRepo =
			pkgs.fetchFromGitHub {
				owner = "futo-org";
				repo = "JustCef";
				rev = "56f844fee7b8d26becbf94d4701e40ba7cd280d5";
				hash = "sha256-+l8e+1MzLlQR0tk+bQwmzXIG/CCHWEYbl3PNQonZ/Fo=";
			};
	in {
		packages.${system}.default = let
		in
			pkgs.buildDotnetModule {
				name = "justcef";

				src = sourceRepo;
				pubDir = "./bin/Release/net8.0/${getArch system}/publish";
				# installPath = "$out";

				dontDotnetBuild = true;

				# preInstall = ''
				# 	mkdir -p $pubDir/wwwroot
				# # # 	This gets handled by ../flake.nix
				# # 	ln -s ${pkgs.grayjayPackages.web} $pubDir/wwwroot/web
				# '';

				postInstall = ''
					cp -r $pubDir/ $out/
				'';

				# fixupPhase = ''
				# 	rm -rf $out/lib
				# '';

				meta = {
					description = "Grayjay's JustCef library";
				};
			};
	};
}
