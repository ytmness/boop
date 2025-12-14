#!/bin/bash

# Script para probar la app en simulador con configuración Release
# Esto te permitirá ver cómo se ve realmente en el dispositivo

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}📱 Compilando en modo Release para simulador...${NC}"
echo ""

# Obtener el ID del simulador iPhone activo
SIMULATOR_ID=$(xcrun simctl list devices | grep "iPhone" | grep "Booted" | head -1 | grep -o "[0-9A-F-]\{36\}")

if [ -z "$SIMULATOR_ID" ]; then
    echo -e "${YELLOW}⚠️  No hay simulador ejecutándose${NC}"
    echo "Iniciando iPhone 16 Pro..."
    xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || true
    open -a Simulator
    sleep 3
    SIMULATOR_ID=$(xcrun simctl list devices | grep "iPhone 16 Pro" | grep "Booted" | head -1 | grep -o "[0-9A-F-]\{36\}")
fi

echo -e "${GREEN}📱 Usando simulador: $SIMULATOR_ID${NC}"
echo ""

# Compilar en Release
echo -e "${YELLOW}🔨 Compilando en Release...${NC}"
xcodebuild -project BoopApp.xcodeproj \
    -scheme BoopApp \
    -configuration Release \
    -destination "id=$SIMULATOR_ID" \
    -derivedDataPath build/Release \
    build 2>&1 | grep -E "(BUILD|error:|warning:|Compiling)" || true

echo ""
echo -e "${GREEN}✅ Compilación completada${NC}"
echo ""
echo -e "${YELLOW}📦 Instalando en simulador...${NC}"

# Encontrar la app compilada
APP_PATH=$(find build/Release/Build/Products/Release-iphonesimulator -name "BoopApp.app" | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ No se encontró la app compilada"
    exit 1
fi

# Instalar
xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"

echo ""
echo -e "${GREEN}✅ App instalada${NC}"
echo ""
echo -e "${YELLOW}🚀 Iniciando app...${NC}"

# Ejecutar
xcrun simctl launch "$SIMULATOR_ID" com.boop.app

echo ""
echo -e "${GREEN}✅ ¡App ejecutándose en modo Release!${NC}"
echo ""
echo -e "${YELLOW}💡 Ahora estás viendo la app con las mismas optimizaciones que en el dispositivo real${NC}"
echo ""

