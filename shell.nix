{ pkgs ? import <nixpkgs> {} }:
with pkgs; mkShell {
    name = "Haskell";
    buildInputs = [ (haskell.packages.ghc844.ghcWithPackages (pkgs: [
                        pkgs.hmatrix
                        pkgs.hoogle
                    ]))
                    haskellPackages.hlint
                    haskellPackages.hindent
                    libiconv
                    python36
                    python36Packages.numpy
                    python36Packages.pandas
                    python36Packages.scikitlearn
                    python36Packages.flake8
                  ];
    shellHook = ''
        if [ $(uname -s) = "Darwin" ]; then
            alias ls='ls --color=auto'
            alias ll='ls -al'
        else
            alias open="xdg-open"
        fi

        alias hlint=hlint -c=never
        alias hindent="hindent --indent-size 4 --sort-imports --line-length 79"
        alias flake8="flake8 --ignore E124,E128,E201,E203,E241,W503"
    '';
}
