# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, ivory }:

cabal.mkDerivation (self: {
  pname = "ivory-stdlib";
  version = "0.1.0.0";
  src = ./.;
  buildDepends = [ filepath ivory ];
  meta = {
    homepage = "http://smaccmpilot.org/languages/ivory-introduction.html";
    description = "Ivory standard library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
