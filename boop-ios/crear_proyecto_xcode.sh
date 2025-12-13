#!/bin/bash

# Script para crear proyecto Xcode desde línea de comandos

cd "$(dirname "$0")"

PROJECT_NAME="BoopApp"
BUNDLE_ID="com.boop.app"
PROJECT_DIR="."

echo "🚀 Creando proyecto Xcode: $PROJECT_NAME..."

# Crear estructura de directorios si no existe
mkdir -p "$PROJECT_NAME/$PROJECT_NAME"

# Crear Package.swift para usar Swift Package Manager
cat > Package.swift << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BoopApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "BoopApp",
            targets: ["BoopApp"]),
    ],
    targets: [
        .target(
            name: "BoopApp",
            path: "BoopApp/BoopApp")
    ]
)
EOF

# Generar proyecto Xcode desde Package.swift
echo "📦 Generando proyecto Xcode desde Package.swift..."
swift package generate-xcodeproj 2>/dev/null || echo "Usando xcodegen alternativo..."

# Método alternativo: usar xcodegen si está disponible
if command -v xcodegen &> /dev/null; then
    echo "✅ xcodegen encontrado, generando proyecto..."
    
    # Crear project.yml para xcodegen
    cat > project.yml << EOF
name: BoopApp
options:
  bundleIdPrefix: com.boop
  deploymentTarget:
    iOS: 17.0
targets:
  BoopApp:
    type: application
    platform: iOS
    deploymentTarget: 17.0
    sources: 
      - BoopApp/BoopApp
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.boop.app
      SWIFT_VERSION: 5.9
      TARGETED_DEVICE_FAMILY: 1,2
      INFOPLIST_FILE: BoopApp/BoopApp/Info.plist
      ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
      ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
EOF
    
    xcodegen generate
    echo "✅ Proyecto generado con xcodegen"
else
    echo "⚠️  xcodegen no está instalado"
    echo "Instalando con Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew install xcodegen
        xcodegen generate
        echo "✅ Proyecto generado"
    else
        echo "❌ Homebrew no está instalado"
        echo "Por favor instala xcodegen manualmente:"
        echo "  brew install xcodegen"
        exit 1
    fi
fi

echo ""
echo "✅ ¡Proyecto Xcode creado exitosamente!"
echo ""
echo "📂 Ubicación: $(pwd)/$PROJECT_NAME.xcodeproj"
echo ""
echo "Para abrirlo:"
echo "  open $PROJECT_NAME.xcodeproj"
echo ""
echo "Para compilar desde terminal:"
echo "  xcodebuild -project $PROJECT_NAME.xcodeproj -scheme $PROJECT_NAME -destination 'platform=iOS Simulator,name=iPhone 15 Pro'"
echo ""

