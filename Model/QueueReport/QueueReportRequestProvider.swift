//
//  QueueReport.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
class QueueReportRequestProvider {
    static let shared = QueueReportRequestProvider()
    
    private lazy var database = Firestore.firestore()
    
//    func fetchQueueReport(targetStoreID: String, completion: @escaping (Result<[QueueReport], Error>) -> Void) {
//        database.collection("stores").document(targetStoreID).collection("queueReport").getDocuments { querySnapshot, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                var reports = [QueueReport]()
//                for document in querySnapshot!.documents {
//                    do {
//                        if let report = try document.data(as: QueueReport.self, decoder: Firestore.Decoder()) {
//                            reports.append(report)
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                }
//                completion(.success(reports))
//            }
//        }
//    }
    
    func publishQueueReport(targetStoreID: String, report: inout QueueReport, completion: @escaping (Result<Int, Error>) -> Void) {
        let docment = database.collection("stores").document(targetStoreID)
        report.createdTime = Date().timeIntervalSince1970
        
        do {
            let encodedData = try Firestore.Encoder().encode(report)
            try docment.updateData([
                "queueReport": FieldValue.arrayUnion([encodedData])
            ])
        } catch {
            completion(.failure(error))
        }
        completion(.success(report.queueCount))
    }
}
