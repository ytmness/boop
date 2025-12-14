#!/bin/bash

cd /Users/user284318/Desktop/boop

echo "📦 Verificando estado de Git..."
git status

echo ""
echo "➕ Agregando archivos..."
git add .

echo ""
echo "📝 Creando commit..."
git commit -m "✨ Proyecto SwiftUI con Liquid Glass ejecutándose

🎨 Características implementadas:
- App SwiftUI nativa con Liquid Glass (iOS 26+)
- Proyecto Xcode configurado y funcionando
- SplashView con animaciones
- LoginView con efectos glass
- MainTabView con navegación
- EventsHubView, ProfileView, ExploreView
- GlassComponents reutilizables
- Compilación exitosa en iPhone 17 Pro simulador

✅ Estado: App ejecutándose correctamente
🚀 Build: SUCCESS
📱 Simulador: iPhone 17 Pro (iOS 26.1)
"

echo ""
echo "🚀 Subiendo a GitHub..."
git push

echo ""
echo "✅ ¡Cambios subidos exitosamente!"

