let
  hm = import ./. { };

  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/fa83fd837f3098e3e678e6cf017b2b36102c7211.tar.gz";
    sha256 = "sha256-e7VO/kGLgRMbWtpBqdWl0uFg8Y2XWFMdz0uUJvlML8o=";
  }) { };
in

hm.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    {
      home.stateVersion = "26.05";
      home.username = "foo";
      home.homeDirectory = "/home/foo";
    }
    {
      programs =
        let
          enable = {
            enable = true;
            enableGitIntegration = true;
          };
        in
        {
          delta = enable;
          # FIXME(leana8959): these two aren't caught by the tests.
          diff-highlight = enable;
          diff-so-fancy = enable;
          patdiff = enable;
        };
    }
  ];
}
