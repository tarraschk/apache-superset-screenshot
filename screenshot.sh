#!/bin/bash

# Variables
SUPERSET_URL="http://SUPERSET_URL"
USERNAME="SUPERSET_USERNAME"
PASSWORD="SUPERSET_PASSWORD"
DASHBOARD_SLUG="DASHBOARD_SLUG"
SCREENSHOT_PATH="dashboard_screenshot.png"

# Nettoyer les cookies anciens
rm -f cookies.txt

# Obtenir le token CSRF
CSRF_TOKEN=$(curl -c cookies.txt -b cookies.txt -s "$SUPERSET_URL/login/" | grep -oP 'name="csrf_token" type="hidden" value="\K[^"]+')

# Se connecter à Superset
curl -c cookies.txt -b cookies.txt -s -X POST "$SUPERSET_URL/login/" \
  -d "csrf_token=$CSRF_TOKEN" \
  -d "username=$USERNAME" \
  -d "password=$PASSWORD"

# Vérifier si Puppeteer est installé, sinon l'installer
type npm >/dev/null 2>&1 || { echo "npm est requis mais non installé. Veuillez l'installer puis relancer le script. // npm is required but not installed. Please install it and run again this script."; exit 1; }
npm list puppeteer >/dev/null 2>&1 || { echo "puppeteer est requis mais non installé. Veuillez l'installer avec la commande : npm install puppeteer. // puppeteer is required but not installed. Please install it with this command: npm install puppeteer."; exit 1; }

cookies_name="session"
cookies_path="/"
cookies_expires="-1"
cookies_domain="$(echo $SUPERSET_URL | cut -d '/' -f3 | cut -d ':' -f1)"
cookies_value="$(tail -n1 cookies.txt | cut -d$'\t' -f 7)"

cat <<EOF > "cookies.json"
{"name": "$cookies_name","value": "$cookies_value","domain": "$cookies_domain","path": "$cookies_path","expires": $cookies_expires,"secure": false, "httpOnly": false}
EOF

# Créer un script Node.js pour capturer la capture d'écran
cat <<EOF > screenshot.js
const puppeteer = require('puppeteer');
const fs = require('fs');
(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();
    
    // Lire les cookies du fichier cookies.json (format Netscape)
    const cookies = JSON.parse(fs.readFileSync('cookies.json', 'utf8'));
    if (cookies.length === 0) {
        console.error("Aucun cookie valide trouvé, vérifiez le fichier cookies.json");
        process.exit(1);
    }
    
    console.log("Cookies chargés:", cookies);
    await browser.setCookie(cookies);
    await page.goto('$SUPERSET_URL/superset/dashboard/$DASHBOARD_SLUG', { waitUntil: 'networkidle2' });
    console.log("Page chargée, attente de 30s pour charger les graphes...");
    await new Promise(resolve => setTimeout(resolve, 30000)); // Remplace waitForTimeout par setTimeout
    console.log("Capture d'écran en cours...");
    const bodyWidth = await page.evaluate(() => document.body.scrollWidth);
    const bodyHeight = await page.evaluate(() => document.body.scrollHeight);
    await page.setViewport({ width: bodyWidth, height: bodyHeight });
    await page.screenshot({ path: '$SCREENSHOT_PATH', fullPage: true });
    await browser.close();
})();
EOF

# Exécuter le script Node.js
node screenshot.js

# Nettoyage
test -f screenshot.js && rm screenshot.js

echo "Capture d'écran enregistrée sous $SCREENSHOT_PATH"
