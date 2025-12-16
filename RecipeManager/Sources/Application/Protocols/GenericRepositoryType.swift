import Foundation

public protocol GenericRepositoryType {
    associatedtype T: Identifiable
    
    func getAll() async throws -> [T]
    func getById(id: T.ID) async throws -> T?
    func add(_ item: T) async throws
    func update(_ item: T) async throws
    func delete(id: T.ID) async throws
}
