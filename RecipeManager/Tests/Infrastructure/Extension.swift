import XCTest

extension XCTestCase {
    func removeTestFile(named fileName: String) throws {
        let fileManager = FileManager.default
        
        // matches logic in JsonRepository
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = documents.appendingPathComponent("\(fileName).json")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
}
