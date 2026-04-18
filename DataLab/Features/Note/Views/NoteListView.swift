//
//  NoteDetailView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 17.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NoteListView: View {
    @State private var notes: [Note] = []
    @State private var showCreateNote = false
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: EditNoteView(note: note)) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.reminderDate, style: .date)
                            .font(.subheadline)
                    }
                    .padding(8)
                }
                .onDelete(perform: deleteNote)
            }
            .navigationTitle("MyNotes".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateNote.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateNote) {
                CreateNoteView { newNote in
                    notes.append(newNote)
                }
            }
            .onAppear {
                fetchNotes()
            }
        }
    }
    
    func fetchNotes() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("Users").document(userUID).collection("Notes").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                notes = snapshot.documents.compactMap { try? $0.data(as: Note.self) }
            }
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        offsets.forEach { index in
            let note = notes[index]
            
            Firestore.firestore().collection("Users").document(userUID).collection("Notes").document(note.id!).delete { error in
                if let error = error {
                    print("Error deleting note: \(error.localizedDescription)")
                } else {
                    notes.remove(atOffsets: offsets)
                }
            }
        }
    }
}







