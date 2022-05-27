//
//  Store.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class StoreRequestProvider {
    static let shared = StoreRequestProvider()

    private lazy var database = Firestore.firestore()

    func fetchStores(completion: @escaping (Result<[Store], Error>) -> Void) {
        database.collection("stores").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var stores: [Store] = []
                guard let snapshot = querySnapshot else { return }
                for document in snapshot.documents {
                    do {
                        if let store = try document.data(as: Store.self, decoder: Firestore.Decoder()) {
                            stores.append(store)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(stores))
            }
        }
    }

    func adminPublishNewStore(store: inout Store, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("stores").document()
        store.storeID = docment.documentID
        do {
            try docment.setData(from: store)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
    }

    func collectStore(currentUserID: String, tagertStoreID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let tagertStoreDocment = database.collection("stores").document(tagertStoreID)
        let currentUserDocment = database.collection("accounts").document(currentUserID)

        tagertStoreDocment.updateData([
            "collectedUser": FieldValue.arrayUnion([currentUserID]),
        ])
        currentUserDocment.updateData([
            "collectedStore": FieldValue.arrayUnion([tagertStoreID]),
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("已收藏"))
            }
        }
    }

    func unCollectStore(currentUserID: String, tagertStoreID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let tagertStoreDocment = database.collection("stores").document(tagertStoreID)
        let currentUserDocment = database.collection("accounts").document(currentUserID)

        tagertStoreDocment.updateData([
            "collectedUser": FieldValue.arrayRemove([currentUserID]),
        ])
        currentUserDocment.updateData([
            "collectedStore": FieldValue.arrayRemove([tagertStoreID]),
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("已取消收藏"))
            }
        }
    }

    func listenStore(completion: @escaping (Result<Store, Error>) -> Void) {
        // [START listen_document]
        database.collection("stores").addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let snapshot = querySnapshot else {
                return
            }
            snapshot.documentChanges.forEach { diff in
                if diff.type == .modified {
                    do {
                        if let data = try diff.document.data(as: Store.self, decoder: Firestore.Decoder()) {
                            completion(.success(data))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
