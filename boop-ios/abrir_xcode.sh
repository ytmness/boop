#!/bin/bash

# Script para abrir el proyecto en Xcode

cd "$(dirname "$0")"

echo "🚀 Abriendo Xcode en el directorio del proyecto..."
open -a Xcode .

echo ""
echo "📋 Pasos para crear el proyecto:"
echo ""
echo "1. En Xcode: File → New → Project (Cmd + Shift + N)"
echo ""
echo "2. Selecciona 'iOS' → 'App' → Next"
echo ""
echo "3. Configura el proyecto:"
echo "   ✓ Product Name: BoopApp"
echo "   ✓ Team: (tu cuenta de desarrollador)"
echo "   ✓ Organization Identifier: com.boop"
echo "   ✓ Bundle Identifier: com.boop.app"
echo "   ✓ Interface: SwiftUI"
echo "   ✓ Language: Swift"
echo "   ✓ Storage: None"
echo "   ✓ Include Tests: ✗ (opcional)"
echo ""
echo "4. Guarda en: $(pwd)"
echo "   (IMPORTANTE: guárdalo en esta carpeta)"
echo ""
echo "5. Una vez creado, ARRASTRA todos los archivos .swift desde:"
echo "   $(pwd)/BoopApp/BoopApp/"
echo "   al proyecto en Xcode"
echo ""
echo "6. Elimina los archivos generados automáticamente (ContentView.swift, etc.)"
echo ""
echo "7. Asegúrate de que Info.plist esté en el proyecto"
echo ""
echo "8. Presiona Cmd + R para compilar y ejecutar"
echo ""

