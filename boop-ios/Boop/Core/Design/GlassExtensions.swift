import SwiftUI

/// Extensiones para Liquid Glass nativo de iOS 26+
/// Replica el patrón del ejemplo de liquidglass
extension View {
    /// Aplica efecto Liquid Glass nativo (iOS 26+) o fallback a material
    @ViewBuilder
    func boopGlassEffect(interactive: Bool = true) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(interactive ? .clear.interactive() : .clear)
        } else {
            self.background(.ultraThinMaterial)
        }
    }
    
    /// Botón circular con Liquid Glass (como en el ejemplo)
    @ViewBuilder
    func boopGlassCircleButton(
        diameter: CGFloat = 64,
        tint: Color = .white
    ) -> some View {
        self
            .foregroundStyle(tint)
            .frame(width: diameter, height: diameter)
            .contentShape(Circle())
            .boopGlassEffect(interactive: true)
            .clipShape(Circle())
    }
    
    /// Contenedor con Liquid Glass y spacing (como GlassEffectContainer del ejemplo)
    @ViewBuilder
    func boopGlassContainer(
        spacing: CGFloat = 16,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 20
    ) -> some View {
        self
            .padding(padding)
            .boopGlassEffect(interactive: true)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// Namespace para glassEffectID (iOS 26+)
@available(iOS 26.0, *)
struct GlassNamespace: EnvironmentKey {
    static let defaultValue = Namespace()
}

extension EnvironmentValues {
    @available(iOS 26.0, *)
    var glassNamespace: Namespace {
        get { self[GlassNamespace.self] }
        set { self[GlassNamespace.self] = newValue }
    }
}

// MARK: - GlassEffectContainer Wrapper
/// Contenedor para agrupar elementos con Liquid Glass y gestionar fusiones automáticas
@available(iOS 26.0, *)
struct GlassEffectContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        // En iOS 26+, GlassEffectContainer es nativo de SwiftUI
        // Este wrapper permite usar la API cuando esté disponible
        content
    }
}

// Fallback para versiones anteriores
struct GlassEffectContainerFallback<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        content
    }
}

