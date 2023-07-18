{
  description = "The homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
  in rec {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        {
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.hostPlatform.system = "aarch64-linux";
          # or for 32-bit
          # nixpkgs.hostPlatform.system = "armv7l-linux";
          nixpkgs.buildPlatform.system = system;

          # https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
          system.stateVersion = "23.05";

          systemd.services.sshd.wantedBy = ["multi-user.target"];
          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAxQgK8l3oFg1yzEwrMtPFOBx0EzqbwAH04kudBJYcHt3xUvuelttJFqIaLCn+zazPO+4q0b0JThqFyzxTUBykm8lC3Jhnj1cLOTw23ZzU5iwDNI3UqQIS1Mxzj6zcs5n1pt1Plm26ZBsIDkKNdQm0vvBBOmZ15LRTTrlU4lqtXD80lduJ8ZQnZeLIq8NheiTkjjc6gcTf/iNStf/BrgLAf2gs1s0o7Qqpmfe8LIWnOuqgNddn6ewkOPYDXwQpy2qbUHp3AuR7vkNeE1aG9DjvnshNvBv+KeIYybRlAnSLw0EM2Fkaz86Qemu9Gse/c3xofnM89NZyJfYav5IEZyn3qsjtXzrKPu4rCBQIE1vs8W/y9FoaNFIWOgGq86zxaVa3ix6IujgPkbQlS72jpJWtWdGfnFKetJUgRu7Y7/gHUdKa0aPkAQ58JuU3sO1jVQGpYMDxKxHJ0LxJM6MwcYmNKpmpyldZEqg4nFoXzlOiRAxiBx2dPMp1+Qrs4MvhMiE= andrew@carbide"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDd41siljusZNnvscLFujgkNiXM/qFpcaMdKwxC0GEm+980XSfH6P+FyUcuGntnrHcUExjhm2L6JoHbsz992PyGSqlb4mtcdwqdbCuTJWGo5lk4JJu/s74m1UGwGvSTwgv/R4UmBWCGfsJFdE8t1Oc2wmsHDbI6xRKyBnG8/zl3NFX7jKw0Ayz2LWIJdqW/FqRmOi6VdCcglRRmh1naAVcElBf2o/l4DRlvngIwOkhOHe3uy/foCVXW4/YvsIXsxuXlWrgGDz7MtR3ZBqqaSM4ORxLBG4Gpy80AlISRYru1FXWWG0S1rvs9jw6qcBC0xCfA+3fhoykvytuA/gjOxJLOQK5r8otUZxi72DveAEbr5RTk3w0PfUeyjGJnXZIpD9h7jLUFpDZJQn8Ln1Iw2edPnb4rdky0vLvYThbOPK+qhuUO2l4RuhDnfncXJYX5RMyXi+LrxSYx62mUv/nZbz1L6XVYAN3nZijtZHFXw4Rg9m1JZbFB0bkLbowW6q4lEL0= andrew@xps-15"
          ];
        }
      ];
    };

    packages.${system}.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
  };
}
