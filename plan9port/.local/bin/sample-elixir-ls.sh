#!/bin/bash

# Sample wrapper to run elixir-ls in a specific Conda environment
# Modify as needed and copy to ~/.local/bin/elixir-ls.sh 

CONDA_INSTALL_DIR=${HOME}/miniforge3
CONDA_ELIXIRLS_ENV=${CONDA_DEFAULT_ENV:-pylang}
source "${CONDA_INSTALL_DIR}/etc/profile.d/conda.sh"
conda activate "${CONDA_ELIXIRLS_ENV}"
$HOME/packages/elixir-ls/latest/language_server.sh
