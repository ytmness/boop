# Guía de Uso: Liquid Glass Real iOS

## 📋 Reglas de Diseño

### ✅ DÓNDE USAR Liquid Glass

Liquid Glass real debe usarse **SOLO** en capas flotantes y elementos interactivos superpuestos:

1. **Tab Bar** (ya implementado automáticamente en iOS 26+)
   - La TabView de SwiftUI usa glass real automáticamente
   - **NO tocar** si ya funciona

2. **Toolbars / Navigation Bars**
   ```swift
   .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
   ```

3. **Botones Flotantes (FAB)**
   ```swift
   // Usar GlassButton de Boop/Core/Design/GlassComponents.swift
   GlassButton(title: "Acción", action: {})
   ```

4. **Icon Buttons Circulares**
   ```swift
   Image(systemName: "plus")
       .boopGlassCircleButton(diameter: 44)
   ```

5. **Sheets y Modals Flotantes**
   ```swift
   GlassContainer {
       // Contenido del sheet
   }
   ```

6. **Paneles Laterales Deslizables**

### ❌ DÓNDE NO USAR Liquid Glass

**NO usar glass real** en elementos estáticos o de contenido:

1. **Cards en Grids/Listas**
   - ❌ NO: `GlassContainer` o `GlassSurface` en EventCard
   - ✅ SÍ: Fondo sólido o `.regularMaterial` / `.thinMaterial`

2. **Inputs de Formularios**
   - ❌ NO: Glass real con `glassEffect()`
   - ✅ SÍ: `.thinMaterial` simple (usar `GlassTextField` que ya lo hace correctamente)

3. **Logos e Imágenes de Perfil**
   - ❌ NO: Overlays con glass
   - ✅ SÍ: Fondo sólido o material simple

4. **Contenedores de Contenido Estático**
   - ❌ NO: Glass "pintado" con múltiples capas
   - ✅ SÍ: Material simple o fondo sólido

## 🚫 Prohibiciones Estrictas

Para que el glass se vea **REAL** (no falso), está **PROHIBIDO**:

- ❌ Gradientes dentro de componentes glass
- ❌ Overlays opacos encima del material
- ❌ Strokes/bordes visibles o dobles bordes
- ❌ Sombras marcadas para "simular" profundidad
- ❌ Múltiples capas ZStack con efectos combinados

### Ejemplo INCORRECTO (Glass "Pintado"):
```swift
ZStack {
    RoundedRectangle(cornerRadius: 24)
        .fill(.ultraThinMaterial)
    
    RoundedRectangle(cornerRadius: 24)
        .fill(LinearGradient(...)) // ❌ PROHIBIDO
    
    RoundedRectangle(cornerRadius: 24)
        .strokeBorder(...) // ❌ PROHIBIDO
}
.shadow(...) // ❌ PROHIBIDO
```

### Ejemplo CORRECTO (Glass Real):
```swift
// iOS 26+
glassEffect(.clear.interactive())

// iOS ≤25
.background(.ultraThinMaterial)
```

## 🎨 Sistema de Diseño

### Tokens de Spacing (grid 8pt)

```swift
Spacing.xs      // 4pt
Spacing.sm      // 8pt (base)
Spacing.md      // 12pt
Spacing.lg      // 16pt
Spacing.xl      // 20pt
Spacing.xxl     // 24pt
Spacing.xxxl    // 32pt
```

### Tamaños de Componentes

```swift
// Botones
ButtonSize.primaryHeight              // 52pt
ButtonSize.secondaryHeight            // 48pt
ButtonSize.iconSize                   // 44pt (HIG mínimo)
ButtonSize.iconSizeLarge              // 56pt

// Cards
CardSize.padding                      // 16pt
CardSize.cornerRadius                 // 20pt
CardSize.cornerRadiusSmall            // 16pt
CardSize.cornerRadiusLarge            // 24pt

// Inputs
InputSize.height                      // 52pt
InputSize.cornerRadius                // 16pt
InputSize.padding                     // 16pt
```

## 🔧 Componentes Disponibles

### GlassSurface (Base)

Componente base Apple-safe para Liquid Glass real:

```swift
GlassSurface(cornerRadius: 20, interactive: true) {
    Text("Contenido")
        .padding()
}
```

- iOS 26+: Usa `glassEffect(.clear.interactive())`
- iOS ≤25: Usa `.ultraThinMaterial`
- Sin overlays, gradientes, strokes ni sombras

### GlassButton

Botón primario con glass real (usar solo en botones flotantes):

```swift
GlassButton(title: "Acción", action: {
    // acción
})
```

- Altura: 52pt (ButtonSize.primaryHeight)
- Usa `Capsule` shape con glass real

### GlassTextField

Input con material sutil (NO glass real):

```swift
GlassTextField(
    placeholder: "Email",
    text: $email,
    icon: "envelope"
)
```

- Altura: 52pt
- Material: `.thinMaterial` (NO glass real)

### GlassContainer

Contenedor para sheets/modals flotantes:

```swift
GlassContainer(cornerRadius: 20, padding: 16) {
    // Contenido
}
```

- Usa `GlassSurface` internamente
- Para elementos flotantes, NO para cards estáticas

### Extensiones

```swift
// Aplicar glass effect directamente
.boopGlassEffect(interactive: true)

// Botón circular glass
.boopGlassCircleButton(diameter: 44)
```

## 📱 Ejemplos por Pantalla

### Login
- Logo: Material simple (NO glass)
- Formulario: Cards con `.thinMaterial` (NO glass)
- Botones sociales: `boopGlassCircleButton()` (SÍ glass real)
- Botón login: `GlassButton` (SÍ glass real)

### Events Hub
- Search bar: `.thinMaterial` simple (NO glass)
- EventCard: `.regularMaterial` (NO glass, cards estáticas)
- Botón crear: `boopGlassCircleButton()` (SÍ glass real)

### Profile
- Profile image: Material simple (NO glass)
- Header card: `.thinMaterial` (NO glass)
- Menu items: `.ultraThinMaterial` (NO glass)
- Logout button: `GlassButton` (SÍ glass real)

### Create Event (Sheet)
- Form inputs: `GlassTextField` (material sutil)
- Date picker: `GlassContainer` (SÍ glass real, es flotante)
- Guardar button: `GlassButton` (SÍ glass real)

## 🔍 Debugging

Si el glass se ve "falso":

1. ✅ Verificar que NO hay gradientes dentro
2. ✅ Verificar que NO hay overlays opacos
3. ✅ Verificar que NO hay strokes visibles
4. ✅ Verificar que NO hay sombras marcadas
5. ✅ Verificar que se usa `GlassSurface` o material nativo directamente
6. ✅ Verificar que solo hay UNA superficie de material por componente

## 📚 Referencias

- [Apple HIG - Materials](https://developer.apple.com/design/human-interface-guidelines/materials)
- iOS 26+: `glassEffect()` API
- iOS ≤25: `.ultraThinMaterial` fallback

