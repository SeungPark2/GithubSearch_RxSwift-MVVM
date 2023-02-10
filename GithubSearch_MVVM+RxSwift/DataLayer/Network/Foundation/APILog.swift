//
//  APILog.swift
//  GithubSearch_MVVM+RxSwift
//
//  Created by 박승태 on 2023/02/10.
//

import Foundation

protocol APILog {
    func printRequestInfo(target: TargetType, data: Data, response: HTTPURLResponse)
}

extension APILog {
    func printRequestInfo(target: TargetType, data: Data, response: HTTPURLResponse) {
        var message: String = "\n\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    HTTP REQUEST                    |"
        message += "\n—————————————————————————————————-————————————————---*/"
        message += "\n"
        message += "* METHOD : \(target.method)"
        message += "\n"
        message += "* URL : \(target.baseURL + target.path)"
        message += "\n"
        message += "* PARAM : \(target.params)"
        message += "\n"
        message += "* STATUS CODE : \(response.statusCode)"
        message += "\n"
        message += "* SERVER RESPONSE : \n\(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))"
        message += "\n"
        message += "* iOS RESPONSE : \n\(response)"
        message += "\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    RESPONSE END                     |"
        message += "\n—————————————————————————————————-————————————————---*/"
        println(message)
    }
    
    // MARK: - Log
    
    func println<T>(_ object: T,
                            _ file: String = #file,
                            _ function: String = #function, _ line: Int = #line) {
#if DEBUG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        let process = ProcessInfo.processInfo
        
        var tid:UInt64 = 0;
        pthread_threadid_np(nil, &tid);
        let threadId = tid
        
        Swift.print("\(dateFormatter.string(from: NSDate() as Date)) \(process.processName))[\(process.processIdentifier):\(threadId)] \((file as NSString).lastPathComponent)(\(line)) \(function):\t\(object)")
#else
#endif
    }
}
