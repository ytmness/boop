# 🎯 Empezar Aquí

## Opción Rápida (5 minutos)

1. **Abre Xcode** (busca en Spotlight con `Cmd + Espacio` → escribe "Xcode")

2. **File → New → Project** (o `Cmd + Shift + N`)

3. Selecciona **iOS** → **App** → Click **Next**

4. Configura:
   ```
   Product Name:     BoopApp
   Interface:        SwiftUI
   Language:         Swift
   Bundle ID:        com.boop.app
   ```

5. **MUY IMPORTANTE**: Guarda en:
   ```
   /Users/user284318/Documents/boop/boop-ios/
   ```
   (Esta carpeta donde estás ahora)

6. Una vez creado:
   - Arrastra **toda la carpeta** `BoopApp/BoopApp/` al proyecto Xcode
   - Marca "Copy items if needed"
   - Elimina archivos duplicados generados por Xcode

7. **Cmd + R** para ejecutar

---

## Archivos Listos

✅ **11 archivos Swift** creados:
- LoginView.swift (pantalla de login con glass)
- EventsHubView.swift (grid de eventos)
- ProfileView.swift (perfil con menú)
- GlassCard, GlassButton, GlassBackground (componentes)
- MainTabView (navegación)

✅ **Documentación**:
- `GUIA_RAPIDA.md` → Paso a paso detallado
- `README.md` → Documentación completa
- `MIGRACION.md` → Estrategia Flutter ↔ Swift

---

## ¿Qué Verás?

Una app iOS con:
- 🪟 Efecto Liquid Glass translúcido
- 🌙 Tema oscuro elegante
- 🎨 Gradientes de fondo
- ⚡ Animaciones suaves
- 📱 Navegación por tabs

---

## Problema Común

**Error "Module not found"?**
→ Asegúrate de que el Deployment Target sea iOS 17.0+
→ En el proyecto Xcode: Target → General → Minimum Deployments

---

🎉 **¡Listo para probar!** Solo abre Xcode y sigue los pasos.

