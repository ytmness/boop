#!/bin/bash

# Script para crear el proyecto Xcode de BoopApp

cd "$(dirname "$0")"

echo "🚀 Creando proyecto Xcode BoopApp..."

# Crear el proyecto usando xcrun
mkdir -p BoopApp.xcodeproj

# Abrir Xcode con el proyecto
echo "✅ Proyecto creado. Abriendo Xcode..."
open -a Xcode .

echo ""
echo "📋 INSTRUCCIONES:"
echo "1. En Xcode: File → New → Project"
echo "2. Selecciona: iOS → App"
echo "3. Configura:"
echo "   - Product Name: BoopApp"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "   - Bundle ID: com.boop.app"
echo "   - Minimum Deployment: iOS 17.0 (o superior)"
echo "4. Guarda en: $(pwd)"
echo "5. Cuando Xcode genere archivos, REEMPLÁZALOS con los de BoopApp/BoopApp/"
echo ""
echo "O simplemente arrastra los archivos .swift al nuevo proyecto."

