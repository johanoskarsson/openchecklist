//
//  AddChecklistView.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import SwiftData

struct AddChecklistView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedType: ChecklistType = .todo


    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Checklist Details")
                        .font(.headline)
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Type")
                        .font(.headline)

                    Picker("Checklist Type", selection: $selectedType) {
                        ForEach(ChecklistType.allCases, id: \.self) { type in
                            Text(type.displayName)
                                .tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedType.displayName)
                            .font(.headline)
                        Text(selectedType.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("New Checklist")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChecklist()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveChecklist() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let newChecklist = Checklist(name: trimmedName, type: selectedType)
        modelContext.insert(newChecklist)
        dismiss()
    }
}
