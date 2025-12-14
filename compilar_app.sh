#!/bin/bash

echo "🏗️  Compilando BoopApp..."
echo ""

cd /Users/user284318/Desktop/boop/boop-ios

# Limpiar compilación anterior
echo "🧹 Limpiando compilación anterior..."
xcodebuild clean -project BoopApp.xcodeproj -scheme BoopApp 2>&1 | grep -E "(CLEAN|error:)"

# Compilar
echo ""
echo "⚙️  Compilando proyecto..."
xcodebuild -project BoopApp.xcodeproj \
  -scheme BoopApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug \
  build 2>&1 | grep -E "(BUILD|error:|warning:)"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Compilación exitosa!"
    echo ""
    echo "📱 Instalando en simulador..."
    
    # Instalar en simulador
    xcrun simctl install CB7A9BB4-FA87-4761-8701-230460D662F5 \
      ~/Library/Developer/Xcode/DerivedData/BoopApp-*/Build/Products/Debug-iphonesimulator/BoopApp.app
    
    # Ejecutar app
    echo "🚀 Ejecutando app..."
    xcrun simctl launch CB7A9BB4-FA87-4761-8701-230460D662F5 com.boop.app
    
    echo ""
    echo "✅ ¡App ejecutándose!"
else
    echo ""
    echo "❌ Error en la compilación"
    exit 1
fi

