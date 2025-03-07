# apache-superset-screenshot

Generate Apache Superset screenshots from a Dashboard with Puppeteer

## Why?

The Apache Superset API is very good at generating Charts screenshots. However, exporting a full dashboard is way harder.

This script aims to help exporting a full Superset dashboard in PNG.

## Installation

```
git clone https://github.com/tarraschk/apache-superset-screenshot.git
```

Then, edit file `screenshot.sh` and replace variables `SUPERSET_URL`, `USERNAME`, `PASSWORD`, `DASHBOARD_SLUG` by your Superset URL, your username, your password, and the dashboard slug to capture.

The screenshot will be taking the dashboard full screen.

## Usage

```
bash screenshot.sh
```

You should then get a screenshot like this in the file `dashboard_screenshot.png`.

## Prerequisites

In order to run this script, you will need:
- NPM
- NodeJS 18+
- Puppeteer
- multiples libraries for Puppeteer on Linux

To install them on an APT-like system:

```
# Install npm and NodeJS
apt install npm

# Install puppeteer
npm install puppeteer

# Install libraries
sudo apt update && sudo apt install -y \
   ca-certificates curl fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
   libatk1.0-0 libcups2 libdbus-1-3 libgbm1 libglib2.0-0 libnspr4 libnss3 libpango-1.0-0 \
   libpangocairo-1.0-0 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxfixes3 libxrandr2 \
   libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils
```

To install them on a YUM-like system:

```
# Install npm and NodeJS
yum install npm

# Install puppeteer
npm install puppeteer

# Install libraries
sudo dnf install -y \
   alsa-lib atk cups-libs dbus-glib fontconfig glib2 \
   gtk3 libX11 libXcomposite libXcursor libXdamage libXext \
   libXi libXrandr libXrender libXScrnSaver libXtst nss \
   pango xdg-utils wget
```

## Example of a dashboard exported with this tool

![dashboard_screenshot](https://github.com/user-attachments/assets/6db0d017-fcc8-4c41-8a60-b0707780678b)

## Licence

MIT

## About

Made in 🇫🇷 with ❤️ by Maxime ALAY-EDDINE
