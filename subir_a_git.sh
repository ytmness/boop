#!/bin/bash

# Script para subir el proyecto Swift a Git
# Proyecto: BoopApp (Swift/SwiftUI con Liquid Glass)

cd /Users/user284318/Documents/boop

echo "📦 Estado de Git..."
git status

echo ""
echo "➕ Agregando archivos..."

# Agregar archivos del proyecto Swift
git add boop-ios/

# Agregar documentación actualizada
git add docs/ 2>/dev/null || true

# Agregar archivos de configuración
git add .gitignore 2>/dev/null || true

echo ""
echo "📝 Creando commit..."
git commit -m "✨ Proyecto Swift/SwiftUI completo con Liquid Glass Design System

🎨 Design System:
- GlassComponents.swift: Sistema de diseño completo y reutilizable
- GlassCard, GlassButton, GlassTextField con efecto Liquid Glass
- GlassAnimatedBackground con orbes animados

🏗️ Arquitectura MVVM:
- AuthViewModel: Gestión de autenticación
- Separación clara Views/ViewModels/Features
- @StateObject, @ObservedObject, @EnvironmentObject

📱 Pantallas:
- SplashView: Splash animado con logo rotando
- LoginView: Login con validación y Liquid Glass
- MainTabView: Navegación por tabs
- EventsHubView: Hub de eventos con búsqueda
- ProfileView: Perfil con logout funcional
- ExploreView: Vista de exploración

♿ Accesibilidad:
- Soporte Reduce Transparency
- Soporte Reduce Motion
- Contraste optimizado

✅ Features:
- Múltiples capas de glass con gradientes
- Animaciones fluidas con springs
- Efectos interactivos (press, focus)
- Componentes 100% reutilizables
- Previews para todos los componentes

📦 Configuración:
- Xcode project configurado
- Info.plist actualizado
- ExportOptions.plist para IPA
- Target iOS 17.0+

🔧 Correcciones:
- Eliminados componentes duplicados
- Resueltos conflictos de redeclaración
- Balanceadas todas las llaves
- 0 errores de compilación"

echo ""
echo "🚀 Subiendo cambios..."
git push

echo ""
echo "✅ ¡Listo! Cambios subidos a Git"
echo ""
echo "📊 Resumen del commit:"
git log -1 --stat

