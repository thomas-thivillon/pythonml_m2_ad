#!/bin/bash
# =============================================================================
# Script d'initialisation SSP Cloud - session d'examen
# Rend l'écran JupyterLab reconnaissable depuis le fond de la salle :
#   1. thème sombre par défaut ;
#   2. bordure orange vif tout autour de la fenêtre.
# Le script s'exécute au démarrage du service, avant le lancement de JupyterLab.
# =============================================================================

# Une étape qui échoue ne doit pas empêcher le service de démarrer.
set +e

# Dossiers de configuration (on respecte les variables de l'image si elles existent)
CONFIG_DIR="${JUPYTER_CONFIG_DIR:-$HOME/.jupyter}"
SETTINGS_DIR="${JUPYTERLAB_SETTINGS_DIR:-$CONFIG_DIR/lab/user-settings}"

echo "[init-examen] Configuration dans : $CONFIG_DIR"

# -----------------------------------------------------------------------------
# 1. Thème sombre par défaut
# -----------------------------------------------------------------------------
THEME_DIR="$SETTINGS_DIR/@jupyterlab/apputils-extension"
mkdir -p "$THEME_DIR"
cat > "$THEME_DIR/themes.jupyterlab-settings" <<'EOF'
{
    "theme": "JupyterLab Dark"
}
EOF
echo "[init-examen] Thème sombre configuré."

# -----------------------------------------------------------------------------
# 2. Bordure orange (feuille de style personnalisée, JupyterLab >= 4.1)
#    Le cadre est dessiné par-dessus la page : il ne décale pas l'interface
#    et ne bloque pas les clics.
# -----------------------------------------------------------------------------
mkdir -p "$CONFIG_DIR/custom"
cat > "$CONFIG_DIR/custom/custom.css" <<'EOF'
body::after {
    content: "";
    position: fixed;
    inset: 0;
    border: 10px solid #ff7a00;
    pointer-events: none;
    z-index: 100000;
}
EOF

# Activation de la feuille de style. On l'ajoute dans les deux fichiers
# que JupyterLab peut lire, sans créer de doublon si le script tourne deux fois.
for CFG in "$CONFIG_DIR/jupyter_server_config.py" "$CONFIG_DIR/jupyter_lab_config.py"; do
    touch "$CFG"
    if ! grep -q "LabApp.custom_css" "$CFG"; then
        echo "c.LabApp.custom_css = True" >> "$CFG"
    fi
done
echo "[init-examen] Bordure orange configurée."

# -----------------------------------------------------------------------------
# Information utile pour le test : version de JupyterLab de l'image
# -----------------------------------------------------------------------------
if command -v jupyter >/dev/null 2>&1; then
    echo "[init-examen] Version de JupyterLab : $(jupyter lab --version 2>/dev/null)"
fi

echo "[init-examen] Terminé."
exit 0
