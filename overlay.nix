final: prev: {
  grenewode.vimPlugins.ale = final.vimUtils.buildVimPluginFrom2Nix rec {
    pname = "ale";
    version = "3.1.0";
    src = prev.fetchFromGitHub {
      owner = "dense-analysis";
      repo = "ale";
      rev = "v${version}";

      hash = "sha256-d3Ce2V90dn5ce2NCqaH3ZqXdgmKBrkKTSHmMwd1q7ss=";
    };
    meta.homepage = "https://github.com/dense-analysis/ale/";
  };

  grenewode.vim = final.callPackage ./packages/vim { };
  grenewode.proton-bridge-cli = final.callPackage ./packages/proton-bridge-cli { };

}
