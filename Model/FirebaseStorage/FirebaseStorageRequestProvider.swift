//
//  FirebaseStorageRequestProvider.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/18.
//

import Foundation


import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

class FirebaseStorageRequestProvider {
    static let shared = FirebaseStorageRequestProvider()
    private lazy var storage = Storage.storage().reference()
    
    func postImageToFirebaseStorage(data: Data, fileName: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let imageRef = storage.child("SURU_App_Assets/Comment_Image/\(fileName).jpg")
        // Upload the file to the path "images/rivers.jpg"
        imageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("上傳照片失敗", error)
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
