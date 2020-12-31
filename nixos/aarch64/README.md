# NixOS Aarch64

## Prepare SD

* [SD Image](https://hydra.nixos.org/job/nixos/release-20.09/nixos.sd_image.aarch64-linux)

```sh
wget https://hydra.nixos.org/build/133956761/download/1/nixos-sd-image-20.09.*.*-aarch64-linux.img.zst
nix-shell -p zstd --run "unzstd nixos-sd-image-20.09.*.*-aarch64-linux.img.zst"
sudo dd if=nixos-sd-image-20.09.*.*-aarch64-linux.img of=/dev/sdc bs=4
sudo parted /dev/sdx resizepart 2 100%
sudo e2fsck -f /dev/disk/by-label/NIXOS_SD
sudo resize2fs /dev/disk/by-label/NIXOS_SD
```

## Configure

* [Template config](https://nixos.wiki/wiki/NixOS_on_ARM#NixOS_installation_.26_configuration)

```sh
sudo nixos-generate-config
cat >> /etc/nixos/configuration.nix
boot.kernelPackages = pkgs.linuxPackages_5_4;
swapDevices = [ { device = "/swapfile"; size = 1024; } ];
^D
sudo nix-channel --update
sudo nixos-rebuild switch
```
