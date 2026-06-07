#!/bin/bash
set -e

ICON_NAME="smartphone-icon"
ICON_FILE="${ICON_NAME}.png"
DESKTOP_NAME="tel-ordi"
APP_URL="https://faunasci.github.io/tel-ordi/"
ICON_URL="https://faunasci.github.io/tel-ordi/install_linux_icon_chromium/${ICON_FILE}"
ICONS_DIR="${HOME}/.local/share/icons"
APPS_DIR="${HOME}/.local/share/applications"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║   Installation de l'icône tel-ordi    ║"
echo "╚═══════════════════════════════════════╝"
echo ""

mkdir -p "${ICONS_DIR}" "${APPS_DIR}"

# ── Icône ──────────────────────────────────────────────────────
if [ -f "${SCRIPT_DIR}/${ICON_FILE}" ]; then
    echo "→ Copie de l'icône depuis le répertoire local..."
    cp "${SCRIPT_DIR}/${ICON_FILE}" "${ICONS_DIR}/${ICON_FILE}"
elif command -v wget &>/dev/null; then
    echo "→ Téléchargement de l'icône (wget)..."
    wget -q --show-progress "${ICON_URL}" -O "${ICONS_DIR}/${ICON_FILE}"
elif command -v curl &>/dev/null; then
    echo "→ Téléchargement de l'icône (curl)..."
    curl -L --progress-bar "${ICON_URL}" -o "${ICONS_DIR}/${ICON_FILE}"
else
    echo "✗ Erreur : wget ou curl est requis pour télécharger l'icône."
    exit 1
fi

# ── Fichier .desktop ────────────────────────────────────────────
cat > "${APPS_DIR}/${DESKTOP_NAME}.desktop" <<DESKTOP
[Desktop Entry]
Version=1.0
Type=Application
Name=tel-ordi
Comment=Transfert de fichiers téléphone ↔ ordinateur
Exec=chromium --app=${APP_URL}
Icon=${ICON_NAME}
Terminal=false
Categories=Network;WebBrowser;
Keywords=transfer;fichier;phone;smartphone;
StartupWMClass=chromium
DESKTOP

chmod 644 "${APPS_DIR}/${DESKTOP_NAME}.desktop"

# ── Mise à jour de la base de données desktop ───────────────────
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "${APPS_DIR}" 2>/dev/null || true
fi

echo ""
echo "✓ Installation réussie !"
echo ""
echo "  Icône   → ${ICONS_DIR}/${ICON_FILE}"
echo "  Lanceur → ${APPS_DIR}/${DESKTOP_NAME}.desktop"
echo ""
echo "L'application apparaîtra dans votre menu d'applications."
echo "Vous pouvez aussi la glisser sur le bureau."
