//
//  StorageManager.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/19.
//

import CoreData

typealias CommentDraftResults = (Result<[CommentDraft], Error>) -> Void

typealias CommentDraftResult = (Result<CommentDraft, Error>) -> Void

class StorageManager {
    static let storageManager = StorageManager()
    
    private enum Entity: String, CaseIterable {
        case commentDraft = "CommentDraft"
    }
    
    private enum Draft: String {
        case createTime 
    }
    
    private init() {
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }
    // KVO
    @objc dynamic var comments: [CommentDraft] = []
    
    lazy var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SURU")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistanceContainer.viewContext
    }
    
    func addDraftComment(comment: Comment, image: Data, completion: (Result<Void, Error>) -> Void) {
        let draft = CommentDraft(context: viewContext)
        draft.image = image
        draft.mapping(comment)
        draft.createTime = Double(Date().timeIntervalSince1970)
        save(completion: completion)
    }
    
    func updateToCoreData(commentDraft: CommentDraft, comment: Comment, image: Data, completion: (Result<Void, Error>) -> Void) {
        deleteComment(commentDraft) { _ in
            let draft = CommentDraft(context: viewContext)
            draft.image = image
            draft.mapping(comment)
            draft.createTime = commentDraft.createTime
            save()
        }
    }
    
    func fetchComments(completion: CommentDraftResults = { _ in }) {
        let request = NSFetchRequest<CommentDraft>(entityName: Entity.commentDraft.rawValue)
        
        request.sortDescriptors = [NSSortDescriptor(key: Draft.createTime.rawValue, ascending: true)]
        
        do {
            let comments = try viewContext.fetch(request)
            self.comments = comments
            completion(Result.success(comments))
        } catch {
            completion(Result.failure(error))
        }
    }
    
    func save(completion: (Result<Void, Error>) -> Void = { _ in }) {
        do {
            try viewContext.save()
            fetchComments { result in
                switch result {
                case .success: completion(Result.success(()))
                case .failure(let error): completion(Result.failure(error))
                }
            }
        } catch {
            completion(Result.failure(error))
        }
    }
    func deleteComment(_ comment: CommentDraft, completion: (Result<Void, Error>) -> Void) {
        viewContext.delete(comment)
        save()
    }
    func deleteAllComment(completion: (Result<Void, Error>) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.commentDraft.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
            fetchComments()
        } catch {
            completion(.failure(error))
            return
        }
    }
}

private extension CommentDraft {
    func mapping(_ object: Comment) {
        storeID = object.storeID
        mealName = object.meal
        noodleValue = object.contentValue.noodle
        soupValue = object.contentValue.soup
        happyValue = object.contentValue.happiness
        commentContent = object.contenText
    }
}
