# NixOS x86

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
