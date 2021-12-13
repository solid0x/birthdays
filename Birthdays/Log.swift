import os

class Log {
    
    private static let shared = Logger()
    
    static func debug(_ message: String) {
        shared.debug("\(message)")
    }
    
    static func info(_ message: String) {
        shared.info("\(message)")
    }
    
    static func warning(_ message: String) {
        shared.warning("\(message)")
    }
    
    static func error(_ message: String) {
        shared.error("\(message)")
    }
    
    static func critical(_ message: String) {
        shared.critical("\(message)")
    }
}
