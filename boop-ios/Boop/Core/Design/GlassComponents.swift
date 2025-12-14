import SwiftUI

/// Componentes reutilizables con Liquid Glass REAL (Apple-safe)
/// 
/// IMPORTANTE: Estos componentes usan GlassSurface que aplica glassEffect() nativo
/// sin overlays, gradientes, strokes ni sombras que "pintarían" el glass.
/// 
/// REGLAS:
/// - GlassButton: Usar en botones flotantes o toolbars (NO en formularios)
/// - GlassTextField: Usar material sutil (NO glass real para inputs)
/// - GlassContainer: Usar en sheets/modals flotantes (NO en cards estáticas)

// MARK: - Glass Button (para botones flotantes/toolbars)
struct GlassButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: ButtonStyle = .primary
    
    enum ButtonStyle {
        case primary
        case secondary
    }
    
    private var buttonHeight: CGFloat {
        style == .primary ? ButtonSize.primaryHeight : ButtonSize.secondaryHeight
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: Typography.body, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .padding(.horizontal, ButtonSize.primaryHorizontalPadding)
        }
        .modifier(GlassButtonModifier(style: style))
        .disabled(isLoading)
    }
}

// MARK: - Glass Button Modifier
private struct GlassButtonModifier: ViewModifier {
    let style: GlassButton.ButtonStyle
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    func body(content: Content) -> some View {
        // Liquid Glass: Usar estilos nativos de iOS 26+
        if #available(iOS 26.0, *) {
            if reduceTransparency {
                // Modo accesibilidad: fondo sólido con estilo personalizado
                content
                    .buttonStyle(GlassButtonStyleFallback(style: style))
            } else {
                // Usar estilos nativos .glass y .glassProminent
                content
                    .buttonStyle(style == .primary ? .glassProminent : .glass)
            }
        } else {
            // Fallback para versiones anteriores
            content
                .buttonStyle(GlassButtonStyleFallback(style: style))
        }
    }
}

// MARK: - Glass Button Style Fallback (para accesibilidad y versiones anteriores)
private struct GlassButtonStyleFallback: ButtonStyle {
    let style: GlassButton.ButtonStyle
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                if reduceTransparency {
                    Capsule()
                        .fill(Color(white: 0.3))
                } else {
                    Capsule()
                        .fill(.ultraThinMaterial)
                }
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Glass Text Field (material sutil, NO glass real)
struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var icon: String? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(.white)
                .focused($isFocused)
        }
        .frame(height: InputSize.height)
        .padding(.horizontal, InputSize.padding)
        .background {
            // Material sutil para inputs (NO glass real)
            RoundedRectangle(cornerRadius: InputSize.cornerRadius)
                .fill(.thinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: InputSize.cornerRadius)
                .strokeBorder(
                    isFocused ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

// MARK: - Glass Back Button
struct GlassBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .boopGlassCircleButton(diameter: ButtonSize.iconSize)
        }
    }
}

// MARK: - Glass Container (para sheets/modals flotantes)
struct GlassContainer<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = CardSize.cornerRadius
    var padding: CGFloat = CardSize.padding
    
    init(
        cornerRadius: CGFloat = CardSize.cornerRadius,
        padding: CGFloat = CardSize.padding,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        GlassSurface(cornerRadius: cornerRadius, interactive: true) {
            content
                .padding(padding)
        }
    }
}

