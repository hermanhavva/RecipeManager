import Foundation
import Application
import Domain


public class JSONRepository<T: Codable & Identifiable> : GenericRepositoryType where T.ID == UUID {
    private let fileURL: URL
    private let fileManager: FileManager
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    public init(fileName: String, fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documents.appendingPathComponent("\(fileName).json")
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.outputFormatting = .prettyPrinted
        self.jsonDecoder = JSONDecoder()
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            try? save(items: [])
        }
    }
    
    // MARK: - Internal Helper Methods
    
    internal func fetchAll() async throws -> [T] {
        do {
            let data = try Data(contentsOf: fileURL)
            return try jsonDecoder.decode([T].self, from: data)
        } catch {
            throw NSError(domain: "JSONRepository", code: 1,
                          userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch items: \(error.localizedDescription)",
                NSUnderlyingErrorKey: error
            ])
//            return []
        }
    }
    
    internal func save(items: [T]) throws {
        let data = try jsonEncoder.encode(items)
        try data.write(to: fileURL)
    }
    
    // MARK: - Generic CRUD Operations
    
    public func getAll() async throws -> [T] {
        return try await fetchAll()
    }
    
    public func getById(id: UUID) async throws -> T? {
        let items = try await fetchAll()
        return items.first(where: { $0.id == id })
    }
    
    public func add(_ item: T) async throws {
        var items = try await fetchAll()
        items.append(item)
        try save(items: items)
    }
    
    public func update(_ item: T) async throws {
        var items = try await fetchAll()
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw NSError(domain: "JSONRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Item not found for update"])
        }
        items[index] = item
        try save(items: items)
    }
    
    public func delete(id: UUID) async throws {
        var items = try await fetchAll()
        items.removeAll(where: { $0.id == id })
        try save(items: items)
    }
}
