//
//  QueueReport.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestoreSwift

class QueueReportRequestProvider {
    static let shared = CommentRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
    func fetchQueueReport(targetStoreID: String, completion: @escaping (Result<[StoreQueueReport], Error>) -> Void) {
        database.collection("stores").document(targetStoreID).collection("queueReport").getDocuments { querySnapshot, error in
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
}
