{ 
  pkgs
}:
let

  ha-base = pkgs.dockerTools.pullImage {
    imageName = "ghcr.io/home-assistant/amd64-base";
    imageDigest = "sha256:810b633e779490662f949f00d9cde29bd993e86d2bd56f5ac19c5456305ca1ee";
    sha256 = "0hxgh1fsdnpkb3grwwqnxx351r2bkkcbgkr3msjs2l8wp4hnaxsr";
    finalImageName = "ghcr.io/home-assistant/amd64-base";
    finalImageTag = "latest";
  };

  rtl_433 = pkgs.stdenv.mkDerivation rec {
    name = "rtl_433";
    src = pkgs.fetchFromGitHub {
      owner = "merbanan";
      repo = "rtl_433";
      rev = "master";
      hash = "sha256-qCfPweJeYHIuM1DfDmeDilkV/RLzbzlIe1sIpSx/EYc=";
    };
    nativeBuildInputs = with pkgs; [ pkg-config cmake ];
    buildInputs = with pkgs; [ libusb1 rtl-sdr-osmocom ];
    doCheck = true;
  };

  svc = pkgs.lib.fileset.toSource {
    root = ./.;
    fileset = ./etc;
  };

in

pkgs.dockerTools.buildImage {
  name = "test";
  tag = "latest";
  fromImage = ha-base;
  copyToRoot = pkgs.buildEnv {
   name = "image-root";
   paths = [ 
    rtl_433 
    svc
  ];
   pathsToLink = [ "/bin" "/etc" ];
  };
  config.Entrypoint = [ "/init" ];
}
