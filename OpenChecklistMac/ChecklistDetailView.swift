//
//  ChecklistDetailView.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import SwiftData

struct ChecklistDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let checklist: Checklist

    @State private var newItemText = ""
    @State private var showingAddAlert = false

    private var visibleItems: [ChecklistItem] {
        guard let items = checklist.items else { return [] }
        switch checklist.checklistType {
        case .todo:
            return items.filter { !$0.isCompleted }
        case .persistent:
            return items.sorted { !$0.isCompleted && $1.isCompleted }
        }
    }

    private var hasCheckedItems: Bool {
        checklist.items?.contains { $0.isCompleted } ?? false
    }

    var body: some View {
        VStack {
            List {
                ForEach(visibleItems) { item in
                    HStack {
                        Button {
                            toggleItem(item)
                        } label: {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text(item.text)
                            .strikethrough(item.isCompleted && checklist.checklistType == .persistent)
                            .foregroundColor(item.isCompleted && checklist.checklistType == .persistent ? .secondary : .primary)

                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
                .onDelete(perform: deleteItems)
            }

            HStack {
                TextField("New item", text: $newItemText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        addItem()
                    }

                Button {
                    addItem()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle(checklist.name)
        .toolbar {

            ToolbarItem(placement: .primaryAction) {
                HStack {
                    if hasCheckedItems {
                        Button("Uncheck All") {
                            uncheckAllItems()
                        }
                        .font(.caption)
                    }

                    Text(checklist.checklistType.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(8)
                }
            }
        }
    }

    private func addItem() {
        let trimmedText = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let newItem = ChecklistItem(text: trimmedText, checklist: checklist)
        modelContext.insert(newItem)
        if checklist.items == nil {
            checklist.items = []
        }
        checklist.items?.append(newItem)
        newItemText = ""
    }

    private func toggleItem(_ item: ChecklistItem) {
        withAnimation {
            item.isCompleted.toggle()

            if checklist.checklistType == .todo && item.isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    modelContext.delete(item)
                    if let index = checklist.items?.firstIndex(of: item) {
                        checklist.items?.remove(at: index)
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = visibleItems[index]
                modelContext.delete(item)
                if let checklistIndex = checklist.items?.firstIndex(of: item) {
                    checklist.items?.remove(at: checklistIndex)
                }
            }
        }
    }

    private func uncheckAllItems() {
        withAnimation {
            checklist.items?.forEach { item in
                item.isCompleted = false
            }
        }
    }
}
