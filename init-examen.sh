#!/bin/bash

# Thème sombre
DIR="$HOME/.jupyter/lab/user-settings/@jupyterlab/apputils-extension"
mkdir -p "$DIR"
cat > "$DIR/themes.jupyterlab-settings" <<'EOF'
{ "theme": "JupyterLab Dark" }
EOF

# Bordure orange autour de la fenêtre
mkdir -p "$HOME/.jupyter/custom"
cat > "$HOME/.jupyter/custom/custom.css" <<'EOF'
body { border: 10px solid #ff7a00 !important; }
EOF
echo "c.LabApp.custom_css = True" >> "$HOME/.jupyter/jupyter_server_config.py"

# ISLP (PyTorch en version CPU d'abord, pour éviter un téléchargement de plusieurs Go)
pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
pip install --quiet ISLP
