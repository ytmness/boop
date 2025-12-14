import SwiftUI

/// GlassSurface - Componente base Apple-safe para Liquid Glass
/// 
/// REGLAS DE USO:
/// - Usar SOLO en capas flotantes: tab bars, toolbars, botones flotantes, sheets/modals
/// - NO usar en cards estáticas, inputs, logos o contenedores estáticos
/// 
/// Este componente usa el glassEffect() nativo de iOS 26+ sin overlays, gradientes,
/// strokes ni sombras que "pintarían" el glass y lo harían verse falso.
struct GlassSurface<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat?
    let interactive: Bool
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    init(
        interactive: Bool = true,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.cornerRadius = cornerRadius
        self.interactive = interactive
    }
    
    var body: some View {
        content
            .background {
                if reduceTransparency {
                    // Modo accesibilidad: fondo sólido opaco
                    if let cornerRadius = cornerRadius {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(white: 0.2))
                    } else {
                        Color(white: 0.2)
                    }
                } else {
                    // Liquid Glass real - UNA sola superficie nativa
                    if #available(iOS 26.0, *) {
                        Color.clear
                            .glassEffect(interactive ? .clear.interactive() : .clear)
                    } else {
                        Color.clear
                            .background(.ultraThinMaterial)
                    }
                }
            }
            .ifLet(cornerRadius) { view, radius in
                view.clipShape(RoundedRectangle(cornerRadius: radius))
            }
    }
}

// MARK: - View Extension Helper

extension View {
    /// Helper para aplicar modificadores condicionalmente
    @ViewBuilder
    func ifLet<Value, Transform: View>(
        _ value: Value?,
        transform: (Self, Value) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

