{
  lib,
  symlinkJoin,
  makeWrapper,

  # Wrappers
  rstudioWrapper,
  positronWrapper,
  radianWrapper,

  # IDE's
  R,
  positron,
  radian,
  rstudio,

  recommendedPackages,
  packages,
  extraPackages,

  ide,
  wrapR,
}:
let
  rWrapper = symlinkJoin {
    name = R.name + "-wrapper";
    preferLocalBuild = true;
    allowSubstitutes = false;

    buildInputs = [ R ] ++ recommendedPackages ++ packages;
    paths = [ R ];

    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      cd ${R}/bin
      for exe in *; do
        rm "$out/bin/$exe"

        makeWrapper "${R}/bin/$exe" "$out/bin/$exe" \
          --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
      done
    '';

    # Make the list of recommended R packages accessible to other packages such as rpy2
    passthru = { inherit recommendedPackages; };

    meta = R.meta // {
      # To prevent builds on hydra
      hydraPlatforms = [ ];
      # prefer wrapper over the package
      priority = (R.meta.priority or lib.meta.defaultPriority) - 1;
    };
  };
in
if ide == "rstudio" then
  rstudioWrapper.override {
    inherit
      packages
      rstudio
      recommendedPackages
      ;
  }
else if ide == "radian" then
  radianWrapper.override {
    inherit
      packages
      radian
      wrapR
      recommendedPackages

      ;
  }
else if ide == "positron" then
  positronWrapper.override {
    inherit
      extraPackages
      packages
      positron
      recommendedPackages
      ;
  }
else
  rWrapper
