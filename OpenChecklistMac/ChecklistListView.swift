//
//  ChecklistListView.swift
//  OpenChecklist
//
//  Created by Johan Oskarsson on 9/15/25.
//

import SwiftUI
import SwiftData

struct ChecklistListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authManager: AuthenticationManager
    @Query(sort: \Checklist.createdAt, order: .reverse) private var checklists: [Checklist]
    @State private var showingAddSheet = false
    @State private var showingAccountSheet = false

    var body: some View {
        NavigationSplitView {
            if checklists.isEmpty {
                VStack(spacing: 30) {
                    Spacer()

                    VStack(spacing: 20) {
                        Image(systemName: "checklist")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("No Checklists Yet")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Create your first checklist to get started")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        showingAddSheet = true
                    } label: {
                        Text("Create Checklist")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .navigationTitle("My Checklists")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            showingAccountSheet = true
                        } label: {
                            Label("Account", systemImage: "person.crop.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    AddChecklistView()
                }
                .sheet(isPresented: $showingAccountSheet) {
                    AccountView(authManager: authManager)
                }
            } else {
                List {
                    ForEach(checklists) { checklist in
                        NavigationLink {
                            ChecklistDetailView(checklist: checklist)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(checklist.name)
                                    .font(.headline)
                                HStack {
                                    Text(checklist.checklistType.displayName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(checklist.items?.count ?? 0) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .onDelete(perform: deleteChecklists)
                }
                .navigationTitle("My Checklists")
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Label("Add Checklist", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button {
                            showingAccountSheet = true
                        } label: {
                            Label("Account", systemImage: "person.crop.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    AddChecklistView()
                }
            }
        } detail: {
            VStack {
                Image(systemName: "checklist")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                Text("Select a checklist")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingAccountSheet) {
            AccountView(authManager: authManager)
        }
    }

    private func deleteChecklists(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(checklists[index])
            }
        }
    }
}
