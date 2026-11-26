#!/bin/bash

# Thème sombre
DIR="$HOME/.jupyter/lab/user-settings/@jupyterlab/apputils-extension"
mkdir -p "$DIR"
cat > "$DIR/themes.jupyterlab-settings" <<'EOF'
{ "theme": "JupyterLab Dark" }
EOF

# ISLP (PyTorch en version CPU d'abord, pour éviter un téléchargement de plusieurs Go)
pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
pip install --quiet ISLP
