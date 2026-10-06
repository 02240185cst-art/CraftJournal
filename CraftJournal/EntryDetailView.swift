import SwiftUI

struct EntryDetailView: View {
    @ObservedObject var entry: CraftEntry

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                KnotDivider()
                VStack(alignment: .leading, spacing: 12) {
                    Text(entry.title ?? "Untitled")
                        .font(Zorig.serif(30))
                        .foregroundStyle(Zorig.maroon)
                    Text(entry.craftType ?? "")
                        .font(Zorig.serif(16, weight: .semibold))
                        .foregroundStyle(Zorig.ink)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Zorig.saffron.opacity(0.35))
                        .clipShape(Capsule())
                    if let date = entry.date {
                        Text(date, style: .date)
                            .font(Zorig.serif(15, weight: .regular))
                            .italic()
                            .foregroundStyle(Zorig.indigo)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .zorigCard()
                KnotDivider()
            }
            .padding()
        }
        .background(Zorig.parchment.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .zorigNavigationBar()
    }
}
