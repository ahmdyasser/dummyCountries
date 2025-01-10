import OSLog

enum LogCategory: String {
    case network = "Network"
    case ui = "UI"
    case cache = "Cache"
    case location = "Location"
}

struct AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.dummyCountries"
    private static var loggers: [LogCategory: Logger] = [:]
    
    static func log(_ message: String, category: LogCategory, type: OSLogType = .default, file: String = #file, function: String = #function, line: Int = #line) {
        let logger = loggers[category] ?? Logger(subsystem: subsystem, category: category.rawValue)
        loggers[category] = logger
        
        let metadata = "\(URL(fileURLWithPath: file).lastPathComponent):\(line) \(function)"
        logger.log(level: type, "\(metadata): \(message)")
    }
    
    static func debug(_ message: String, category: LogCategory, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, category: category, type: .debug, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, category: LogCategory, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, category: category, type: .info, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, category: LogCategory, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, category: category, type: .error, file: file, function: function, line: line)
    }
} 
