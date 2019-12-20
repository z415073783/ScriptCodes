//
//  YLLogger.swift
//  UME
//
//  Created by zlm on 2016/10/25.
//  Copyright © 2016年 yealink. All rights reserved.
//

import Foundation
public enum LogLevel: Int {
    case Verbose
    case Debug
    case Info
    case Warning
    case Error
    case Severe
    case None

    public var description: String {
        switch self {
        case .Verbose:
            return "Verbose"
        case .Debug:
            return "Debug"
        case .Info:
            return "Info"
        case .Warning:
            return "Warning"
        case .Error:
            return "Error"
        case .Severe:
            return "Severe"
        case .None:
            return "None"
        }
    }
}
public struct YLLoggerDetails {
    public var logLevel: LogLevel
    public var date: Date
    public var logMessage: String
    public var functionName: String
    public var fileName: String
    public var lineNumber: Int
    public init(logLevel: LogLevel, date: Date, logMessage: String, functionName: String, fileName: String, lineNumber: Int) {
        self.logLevel = logLevel
        self.date = date
        self.logMessage = logMessage
        self.functionName = functionName
        self.fileName = fileName
        self.lineNumber = lineNumber
    }
}

@objc public class YLSDKLogger: NSObject {
    public static let logQueueIdentifier = "com.yealink.yllogger.queue"

    @objc static public let getInstance = YLSDKLogger()
    func instance() -> YLSDKLogger {
        return YLSDKLogger.getInstance
    }
    override init() {
        super.init()
        self.cleanLogFile(path: yllogPath)
        self.openLogServer()

    }
    @objc public class func ocLog(text:String) {
        YLSDKLogger.log("SDK" + text)
    }

    public class func log( _ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String=#file, lineNumber: Int = #line) {
        YLSDKLogger.getInstance.logln(closure, logLevel: LogLevel.None, functionName:functionName, fileName: fileName, lineNumber: lineNumber)
    }

    public class func debug( _ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String=#file, lineNumber: Int = #line) {
        YLSDKLogger.getInstance.logln(closure, logLevel: LogLevel.Debug, functionName:functionName, fileName: fileName, lineNumber: lineNumber)
    }
    public class func error( _ closure:@autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        YLSDKLogger.getInstance.logln(closure, logLevel: LogLevel.Error, functionName:functionName, fileName: fileName, lineNumber: lineNumber)
    }

    public func logln(_ closure:@autoclosure () -> String?, logLevel: LogLevel = .Debug, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        logln(logLevel: logLevel, functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }

    public func logln(logLevel: LogLevel = .Debug, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, closure: () -> String?) {
        if let logMessage = closure() {
            let logDetails: YLLoggerDetails? = YLLoggerDetails(logLevel: logLevel, date: Date(), logMessage: logMessage, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
            self.processLogDetails(logDetails: logDetails!)
        }
    }

    public func processLogDetails(logDetails: YLLoggerDetails) {
        var extendedDetails: String = ""

        var formattedDate: String = logDetails.date.description
        if let dateFormatter = self.dateFormatter {
            formattedDate = dateFormatter.string(from: logDetails.date as Date)
        }
        extendedDetails += "\(formattedDate) "

        extendedDetails += "[\(logDetails.logLevel)] "

        if Thread.isMainThread {
            extendedDetails += "[main] "
        } else {
            if let threadName: String = Thread.current.name {
                if threadName.characters.count != 0 {
                    extendedDetails += "[" + threadName + "] "
                }
            } else if let queueName = String(cString: DispatchQueue.accessibilityLabel()!, encoding: String.Encoding.utf8) {
                if !queueName.isEmpty {
                    extendedDetails += "[" + queueName + "] "
                }
            } else {
                extendedDetails += "[" + String.init(describing: Thread.current) + "] "
            }
        }

        extendedDetails += "[" + (logDetails.fileName as NSString).lastPathComponent + ":" + String(logDetails.lineNumber) + "] "

        extendedDetails += "[" + String(logDetails.lineNumber) + "] "

        extendedDetails += "\(logDetails.functionName) "

        output(logDetails: logDetails, text: "\(extendedDetails)> \(logDetails.logMessage)")

    }
    open class var LogQueue: DispatchQueue {
        struct Statics {
            static var logQueue = DispatchQueue(label: YLSDKLogger.logQueueIdentifier, attributes: [])
        }
        return Statics.logQueue
    }
    public func output(logDetails: YLLoggerDetails, text: String) {
        let outputClosure = {
            let adjustedText = text
            ylTraceInterface(adjustedText)
            print(adjustedText)
            if openWriteLog {
                YLSDKLogger.writeToFile(log: adjustedText)
            }
        }
        outputClosure()
    }

    private var _dateFormatter: DateFormatter?
    public var dateFormatter: DateFormatter? {
        get {
            if _dateFormatter != nil {
                return _dateFormatter
            }

            let defaultDateFormatter = DateFormatter()
            defaultDateFormatter.locale = NSLocale.current
            defaultDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            _dateFormatter = defaultDateFormatter

            return _dateFormatter
        }
        set {
            _dateFormatter = newValue
        }
    }

    let overTimeFilePath: String = NSString.init(format: "%@/Library/Caches/overTime.log", NSHomeDirectory()) as String
    public func writeToOverTimeLog(log: String) {
        YLSDKLOG.writeToFile(log: log, overTimeFilePath)
    }

    public class func writeToFile(log: String, _ path: String? = nil) {
        #if DEBUG
            if UIApplication.shared.applicationState == .background {
                return
            }
            var _logPath = ""
            if path == nil {
                _logPath = getInstance.logPath
            } else {
                _logPath = path!
            }
            let fileManager = FileManager()
            let isExist = fileManager.fileExists(atPath: _logPath)
            if !isExist {
                fileManager.createFile(atPath: _logPath, contents: Data(base64Encoded: ""), attributes: nil)
                fileManager.isWritableFile(atPath: _logPath)
            }
            do {
                var logDataFile = try String(contentsOfFile: _logPath)
                if logDataFile.characters.count > 300000 {
                    logDataFile = logDataFile.substring(to: logDataFile.index(logDataFile.startIndex, offsetBy: 10000))
                }
                let logData = logDataFile + log + "<br>"

                try logData.write(toFile: _logPath, atomically: true, encoding: String.Encoding.utf8)

            } catch {

            }
        #endif
    }

    public let logPath = NSHomeDirectory() + "/Library/Caches/YLLogger.log"

    public func cleanLogFile(path: String) {
        let fileManager = FileManager()
        do {
            if fileManager.fileExists(atPath: path) {
                var logData = try String(contentsOfFile: logPath)
                if logData.characters.count > 100000 {
                    try fileManager.removeItem(atPath: path)
                } else {
                    logData = logData + "<br><br><br>"
                    try logData.write(toFile: logPath, atomically: true, encoding: String.Encoding.utf8)
                }
            }
        } catch {
        }
    }
    var needWriteLog = false
    let logFilePath: String = NSString.init(format: "%@/Library/Caches/diagnose/app_1.log", NSHomeDirectory()) as String
    let crashFilePath: String = NSString.init(format: "%@/Library/Caches/diagnose/crash.log", NSHomeDirectory()) as String
    let yllogPath = NSHomeDirectory() + "/Library/Caches/YLLogger.log"
    public func openLogServer() {
        #if DEBUG
            DispatchQueue.main.async {

                do {
                    self.server = HttpServer()

                    self.server[""] = scopes {
                        do {
                            self.needWriteLog = true
                            let htmlStr = try String(contentsOfFile: self.yllogPath)
                            var htmlStr2 = "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'><head><title></title><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /></head><body>"
                            htmlStr2 = htmlStr2 + htmlStr + "</body></html>"
                            html {
                                body {
                                    inner = htmlStr2
                                }
                            }
                        } catch {
                        }
                    }
                    self.server["/crash"] = scopes {
                        do {
                            //                        errorFilePath
                            var htmlStr = try String(contentsOfFile: errorFilePath)
                            var htmlStr2 = "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'><head><title></title><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /></head><body>"
                            htmlStr = htmlStr.replacingOccurrences(of: "201", with: "<br>201")
                            htmlStr2 = htmlStr2 + htmlStr + "</body></html>"
                            html {
                                body {
                                    inner = htmlStr2
                                }
                            }
                        } catch {

                        }
                    }
                    self.server["/cpu"] = scopes {
                        do {

                            var htmlStr = try String(contentsOfFile: MonitorManager.getInstance.path)
                            var htmlStr2 = "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'><head><title></title><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /></head><body>"
                            htmlStr = htmlStr.replacingOccurrences(of: "201", with: "<br>201")
                            htmlStr2 = htmlStr2 + htmlStr + "</body></html>"
                            html {
                                body {
                                    inner = htmlStr2
                                }
                            }
                        } catch {

                        }
                    }

                    self.server["/log"] = scopes {
                        do {
                            let logs = CrashObjc.allLogMessagesForCurrentProcess()
                            for item in logs! {
                                YLSDKLogger.writeToFile(log: (item as! SystemLogMessage).messageText)
                            }
                            var htmlStr = try String(contentsOfFile: self.logPath)
                            var htmlStr2 = "<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'><head><title></title><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /></head><body>"

                            htmlStr2 = htmlStr2 + "<a href=\"" + self.logPath + "\" download=\"yllog.log\">log下载</a>" + "</body></html>"
                            html {
                                body {
                                    inner = htmlStr2
                                }
                            }
                        } catch {

                        }
                    }
                    self.server["/file"] = shareFile(NSHomeDirectory() + "/Library/Caches/diagnose/app_1.log")
                    self.server["/path"] = shareFilesFromDirectory(NSHomeDirectory())

                    try self.server.start(8989)
                } catch {

                }
            }
        #endif
    }

}
