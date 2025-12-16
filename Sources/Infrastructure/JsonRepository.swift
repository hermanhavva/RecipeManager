import Foundation
import Application
import Domain

public actor JSONRepository<T: Codable & Identifiable>: GenericRepositoryType where T.ID == UUID {
    
    private let fileURL: URL
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    private var cache: [T]?
    
    public init(fileName: String, fileManager: FileManager = .default) {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.fileURL = documents.appendingPathComponent("\(fileName).json")
        
        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.outputFormatting = .prettyPrinted
        self.jsonDecoder = JSONDecoder()
    }
    
    // MARK: - Internal Helpers
    
    private func loadData() throws -> [T] {
        // Return memory cache if available for performance
        if let cache = cache {
            return cache
        }
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let items = try jsonDecoder.decode([T].self, from: data)
            self.cache = items // update cache
            return items
        }
        catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
    
    private func saveData(_ items: [T]) throws {
        do {
            let data = try jsonEncoder.encode(items)
            try data.write(to: fileURL)
            self.cache = items // update cache
        }
        catch {
            throw RecipeAppError.dataSavingError(underlying: error)
        }
    }
    
    // MARK: - GenericRepositoryType Implementation
    
    public func getAll() async throws -> [T] {
        return try loadData()
    }
    
    public func getById(id: UUID) async throws -> T? {
        let items = try loadData()
        return items.first(where: { $0.id == id })
    }
    
    public func add(_ item: T) async throws {
        var items = try loadData()
        items.append(item)
        try saveData(items)
    }
    
    public func update(_ item: T) async throws {
        var items = try loadData()
        
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw DomainError(reason: "Item not found to update, id: \(item.id)")
        }
        
        items[index] = item
        try saveData(items)
    }
    
    public func delete(id: UUID) async throws {
        var items = try loadData()
        items.removeAll(where: { $0.id == id })
        try saveData(items)
    }
}
