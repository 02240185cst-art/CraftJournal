import SwiftUI

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var craftType = crafts[0]
    @State private var image: UIImage?
    @State private var showingCamera = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    Picker("Craft", selection: $craftType) {
                        ForEach(crafts, id: \.self) { craft in
                            Text(craft)
                        }
                    }
                }
                .listRowBackground(Zorig.parchment)

                Section("Photo") {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                    }
                    Button("Take Photo") {
                        showingCamera = true
                    }
                    .tint(Zorig.maroon)
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                }
                .listRowBackground(Zorig.parchment)
            }
            .scrollContentBackground(.hidden)
            .background(Zorig.parchment.ignoresSafeArea())
            .tint(Zorig.maroon)
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showingCamera) {
                CameraView(image: $image)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .tint(Zorig.saffron)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEntry() }
                        .tint(Zorig.saffron)
                        .disabled(title.isEmpty)
                }
            }
            .zorigNavigationBar()
        }
    }

    private func saveEntry() {
        let entry = CraftEntry(context: viewContext)
        entry.id = UUID()
        entry.title = title
        entry.craftType = craftType
        entry.date = Date()
        entry.photo = image?.jpegData(compressionQuality: 0.7)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Could not save: \(error)")
        }
    }
}
