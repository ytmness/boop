#!/bin/bash

# Script para generar IPA de BoopApp para AltServer
# Ejecutar en macOS con Xcode instalado

set -e  # Salir si hay errores

echo "📦 Generando IPA de BoopApp..."

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directorio del proyecto
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# Limpiar builds anteriores
echo -e "${YELLOW}🧹 Limpiando builds anteriores...${NC}"
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData/BoopApp-*

# Verificar que existe el proyecto
if [ ! -f "BoopApp.xcodeproj/project.pbxproj" ]; then
    echo -e "${RED}❌ Error: No se encuentra BoopApp.xcodeproj${NC}"
    exit 1
fi

# Crear directorio de salida
mkdir -p build/ipa

echo -e "${YELLOW}🔨 Compilando y creando archive...${NC}"

# Crear archive sin firma (para desarrollo local)
xcodebuild clean archive \
    -project BoopApp.xcodeproj \
    -scheme BoopApp \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -archivePath build/BoopApp.xcarchive \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    DEVELOPMENT_TEAM="" \
    PROVISIONING_PROFILE_SPECIFIER="" \
    || {
        echo -e "${RED}❌ Error al crear archive${NC}"
        echo -e "${YELLOW}💡 Intenta compilar primero en Xcode para ver errores específicos${NC}"
        exit 1
    }

echo -e "${GREEN}✅ Archive creado exitosamente${NC}"

# Crear estructura del IPA
echo -e "${YELLOW}📦 Creando estructura del IPA...${NC}"
mkdir -p build/ipa/Payload

# Copiar la app al Payload
if [ -d "build/BoopApp.xcarchive/Products/Applications/BoopApp.app" ]; then
    cp -r build/BoopApp.xcarchive/Products/Applications/BoopApp.app build/ipa/Payload/
else
    echo -e "${RED}❌ Error: No se encuentra la app en el archive${NC}"
    exit 1
fi

# Crear el IPA
echo -e "${YELLOW}📦 Comprimiendo IPA...${NC}"
cd build/ipa
zip -r BoopApp.ipa Payload > /dev/null
cd "$PROJECT_DIR"

# Verificar que se creó
if [ -f "build/ipa/BoopApp.ipa" ]; then
    IPA_SIZE=$(du -h build/ipa/BoopApp.ipa | cut -f1)
    echo -e "${GREEN}✅ IPA generado exitosamente!${NC}"
    echo -e "${GREEN}📱 Ubicación: ${NC}$(pwd)/build/ipa/BoopApp.ipa"
    echo -e "${GREEN}📊 Tamaño: ${NC}$IPA_SIZE"
    echo ""
    echo -e "${YELLOW}📋 Para instalar con AltServer:${NC}"
    echo "1. Transfiere el archivo BoopApp.ipa a tu Windows"
    echo "2. Abre AltServer en Windows"
    echo "3. Conecta tu iPhone"
    echo "4. En AltStore, presiona '+' y selecciona el IPA"
else
    echo -e "${RED}❌ Error: No se pudo crear el IPA${NC}"
    exit 1
fi

