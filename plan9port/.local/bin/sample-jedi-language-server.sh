#!/bin/bash

# Sample wrapper to run jedi-language-server in a specific Conda environment
# Modify as needed and copy to ~/.local/bin/jedi-language-server.sh 

CONDA_INSTALL_DIR=${HOME}/miniforge3
CONDA_JEDI_ENV=${CONDA_DEFAULT_ENV:-pylang}
source "${CONDA_INSTALL_DIR}/etc/profile.d/conda.sh"
conda activate "${CONDA_JEDI_ENV}"
jedi-language-server
