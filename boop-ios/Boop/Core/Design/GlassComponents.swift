import SwiftUI

/// Componentes reutilizables con Liquid Glass
/// Siguiendo el patrón del ejemplo de liquidglass

// MARK: - Glass Button
struct GlassButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: ButtonStyle = .primary
    
    enum ButtonStyle {
        case primary
        case secondary
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .boopGlassContainer(
                spacing: 0,
                padding: 0,
                cornerRadius: 20
            )
        }
        .disabled(isLoading)
    }
}

// MARK: - Glass Text Field
struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .foregroundStyle(.white)
            .boopGlassContainer(
                spacing: 0,
                padding: 0,
                cornerRadius: 16
            )
    }
}

// MARK: - Glass Back Button
struct GlassBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .boopGlassCircleButton(diameter: 44)
        }
    }
}

// MARK: - Glass Container (wrapper simple)
struct GlassContainer<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 20
    
    init(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .boopGlassEffect(interactive: true)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

