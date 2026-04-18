//
//  NoteView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 17.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditNoteView: View {
    @State var note: Note
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Title".localized, text: $note.title)
            TextEditor(text: $note.content)
                .frame(height: 140)
            DatePicker("ReminderDate".localized, selection: $note.reminderDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
            
            Button("SaveChanges".localized) {
                saveChanges()
            }
        }
    }
    
    func saveChanges() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let _ = Firestore.firestore().collection("Users").document(userUID).collection("Notes").document(note.id!).setData(from: note)
        presentationMode.wrappedValue.dismiss()
        
        let content = UNMutableNotificationContent()
        content.title = "Нагадування"
        content.body = "Не забудьте про: \(note.title)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: note.reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding reminder: \(error.localizedDescription)")
            } else {
                print("The reminder is scheduled for \(note.reminderDate)")
            }
        }
    }
}












