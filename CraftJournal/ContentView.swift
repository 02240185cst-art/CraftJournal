import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CraftEntry.date, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<CraftEntry>

    @State private var showingAddEntry = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZorigHeader()
                List {
                    ForEach(entries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            EntryRow(entry: entry)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteEntries)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(Zorig.parchment.ignoresSafeArea())
            .navigationTitle("Craft Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Craft Journal")
                        .font(Zorig.serif(20))
                        .foregroundStyle(Zorig.gold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    .tint(Zorig.saffron)
                }
            }
            .zorigNavigationBar()
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
        .tint(Zorig.saffron)
    }

    private func deleteEntries(offsets: IndexSet) {
        offsets.map { entries[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Could not delete: \(error)")
        }
    }
}

struct EntryRow: View {
    @ObservedObject var entry: CraftEntry

    var body: some View {
        HStack(spacing: 12) {
            thumbnail
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title ?? "Untitled")
                    .font(Zorig.serif(18))
                    .foregroundStyle(Zorig.maroon)
                Text(entry.craftType ?? "")
                    .font(Zorig.serif(12, weight: .semibold))
                    .foregroundStyle(Zorig.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Zorig.saffron.opacity(0.35))
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .zorigCard()
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let data = entry.photo, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Zorig.gold, lineWidth: 2))
        } else {
            Image(systemName: "photo")
                .frame(width: 60, height: 60)
                .foregroundStyle(Zorig.gold)
                .background(Zorig.saffron.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Zorig.gold, lineWidth: 2))
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext,
                     PersistenceController.preview.container.viewContext)
}
