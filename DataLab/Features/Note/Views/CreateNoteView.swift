//
//  NewNoteView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 17.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

struct CreateNoteView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var reminderDate: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    var onSave: (Note) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title".localized, text: $title)
                TextEditor(text: $content)
                    .frame(height: 140)
                DatePicker("ReminderDate".localized, selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Button("Save".localized) {
                    let note = Note(userUID: Auth.auth().currentUser?.uid ?? "",
                                    title: title,
                                    content: content,
                                    reminderDate: reminderDate,
                                    createdAt: Date(),
                                    updatedAt: Date())
                    saveNoteForUser(note: note)
                }
            }
            .navigationTitle("CreateNote".localized)
        }
    }
    
    func saveNoteForUser(note: Note) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }

        let _ = Firestore.firestore().collection("Users").document(userUID).collection("Notes").addDocument(from: note)
        onSave(note)
        presentationMode.wrappedValue.dismiss()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder".localized
        content.body = "DontForget".localized + "\(note.title)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: note.reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("ErrorReminder".localized + "\(error.localizedDescription)")
            } else {
                print("ReminderScheduled".localized + "\(note.reminderDate)")
            }
        }
    }
}












