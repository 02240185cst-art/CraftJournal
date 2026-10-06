import SwiftUI

/// Bhutanese-inspired look: maroon (monastery walls), saffron and gold (robes, thangka gilding),
/// parchment (handmade paper), indigo (mineral blue).
enum Zorig {
    static let maroon = Color(red: 0.48, green: 0.11, blue: 0.13)
    static let saffron = Color(red: 0.91, green: 0.64, blue: 0.09)
    static let gold = Color(red: 0.79, green: 0.63, blue: 0.16)
    static let parchment = Color(red: 0.98, green: 0.95, blue: 0.87)
    static let indigo = Color(red: 0.12, green: 0.22, blue: 0.37)
    static let ink = Color(red: 0.20, green: 0.10, blue: 0.08)

    static func serif(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

/// A gold line with a diamond in the middle, like the borders on thangka paintings.
struct KnotDivider: View {
    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Zorig.gold).frame(height: 1.5)
            Image(systemName: "diamond.fill").font(.caption2).foregroundStyle(Zorig.maroon)
            Image(systemName: "diamond.fill").font(.caption).foregroundStyle(Zorig.saffron)
            Image(systemName: "diamond.fill").font(.caption2).foregroundStyle(Zorig.maroon)
            Rectangle().fill(Zorig.gold).frame(height: 1.5)
        }
    }
}

/// Header shown above the list: Dzongkha title (Zorig) and a divider.
struct ZorigHeader: View {
    var body: some View {
        VStack(spacing: 6) {
            Text("ཟོ་རིག")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Zorig.maroon)
            Text("Traditional crafts of Bhutan")
                .font(Zorig.serif(14, weight: .regular))
                .italic()
                .foregroundStyle(Zorig.indigo)
            KnotDivider().padding(.horizontal, 24)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity)
        .background(Zorig.parchment)
    }
}

/// Double border (gold outside, maroon inside) on a parchment card.
struct ZorigCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Zorig.parchment)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Zorig.gold, lineWidth: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Zorig.maroon.opacity(0.55), lineWidth: 1)
                    .padding(5)
            )
    }
}

extension View {
    func zorigCard() -> some View { modifier(ZorigCard()) }

    /// Maroon navigation bar with light text.
    func zorigNavigationBar() -> some View {
        self
            .toolbarBackground(Zorig.maroon, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
