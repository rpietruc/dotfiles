# NixOS x86

## Automount

```sh
nix-env -iA nixos.udisks
udisksctl mount -b /dev/sdc1
udisksctl unmount -b /dev/sdc1
```

## Conda

```sh
nix-env -iA nixos.conda
conda-shell
conda-install
conda init bash
```

### Environments

```sh
conda create -n myenv ipython numpy
conda activate myenv
cat > environment.yml
name: myenv
dependencies:
  - ipython
  - numpy
  - pandas
  - pip
  - pip:
    - ttkthemes
^D
conda env update --file environment.yml
conda install -c conda-forge pyside2
conda deactivate
```

## Qt

```sh
nix-env -qA nixos.qt514.full qtcreator
```

### QtCreator

* Make sure in Kits configuration `g++` path is in `/run/current-system/sw/bin`.
