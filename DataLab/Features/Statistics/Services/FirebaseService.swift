//
//  StatisticsService.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 21.04.2026.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    
    func saveWorkData(_ workData: WorkData, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        var newData = workData
        newData.userUID = userUID
        let collection = Firestore.firestore()
            .collection("Users").document(userUID)
            .collection("WorkData")
        let documentID = "\(workData.year)"
        do {
            try collection.document(documentID).setData(from: newData)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func fetchWorkData(completion: @escaping ([WorkData]?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
            .collection("Users").document(userUID)
            .collection("WorkData")
            .getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    let data = snapshot.documents.compactMap { try? $0.data(as: WorkData.self) }
                    completion(data.sorted(by: { $0.year < $1.year }), nil)
                } else {
                    completion(nil, error)
                }
            }
    }
    
    func deleteWorkData(_ workData: WorkData, completion: @escaping (Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid, let id = workData.id else { return }
        let collection = Firestore.firestore()
            .collection("Users").document(userUID)
            .collection("WorkData")
        collection.document(id).delete { error in
            completion(error)
        }
    }
}
