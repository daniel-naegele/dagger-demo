{
  pkgs ? import <nixpkgs> { },
  ...
}:
with pkgs;
mkShell {
  packages = [
    dagger
  ];

  shellHook = ''

  '';
}
