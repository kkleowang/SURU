//
//  FirebaseRequestProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/13.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseRequestProvider {
    static let shared = FirebaseRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
    func fetchComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        database.collection("comments").order(by: "createdTime", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var comments = [Comment]()
                for document in querySnapshot!.documents {
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(comments))
            }
        }
    }
    
    func fetchStores(completion: @escaping (Result<[Store], Error>) -> Void) {
        database.collection("stores").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var stores = [Store]()
                for document in querySnapshot!.documents {
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
    
    func fetchQueueReport(targetStoreID: String, completion: @escaping (Result<[StoreQueueReport], Error>) -> Void) {
        database.collection("stores").document(targetStoreID).collection("queueReport").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                var reports = [StoreQueueReport]()
                for document in querySnapshot!.documents {
                    do {
                        if let report = try document.data(as: StoreQueueReport.self, decoder: Firestore.Decoder()) {
                            reports.append(report)
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(reports))
            }
        }
    }
    
    func publishComment(comment: inout Comment, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("comments").document()
        comment.commentID = docment.documentID
        comment.createdTime = Date().timeIntervalSince1970
        do {
            try docment.setData(from: comment)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
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
    
    func publishStoreQueueReport(targetStoreID: String, report: inout StoreQueueReport, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("stores").document(targetStoreID).collection("queueReport").document()
        report.reportID = docment.documentID
        report.createdTime = Date().timeIntervalSince1970
        do {
            try docment.setData(from: report)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
    }
    
    func publishRegistedAccount(account: inout Account, completion: @escaping (Result<String, Error>) -> Void) {
        let docment = database.collection("accounts").document()
        account.userID = docment.documentID
        account.createdTime = Date().timeIntervalSince1970
        do {
            try docment.setData(from: account)
        } catch {
            completion(.failure(error))
        }
        completion(.success(docment.documentID))
    }
    
    private func likeStore() {
    }
    private func collectStore() {
    }
    private func loginin() {
    }
    private func deleteAccount() {
    }
}


