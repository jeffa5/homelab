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
          ];
        }
      ];
    };

    packages.${system}.rpi = nixosConfigurations.rpi.config.system.build.sdImage;
  };
}
