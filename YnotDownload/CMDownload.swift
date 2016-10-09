//
//  CMDownload.swift
//  pratice
//
//  Created by bori－applepc on 16/2/3.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import Foundation

protocol DownloadProgressDelegate: class {
    func sendTheProgress(_ progress: Double)
}


protocol DownloadDelegate: class {
    func urlSessionDownloadFinishDownloading(_ cmDownload: CMDownload)
    func urlSessionDownloadComplete(_ cmDownload: CMDownload, error: NSError?)
}

enum DownloadState {
    case downloading
    case cancel
    case suspend
    case finished
    case failed
    case success
}

class CMDownload: NSObject {
    var identifier: String?
    var url: String?
    var existedData: Data?
    var downloadTask: URLSessionDownloadTask?
    var session: Foundation.URLSession?
    var downloadState: DownloadState?
    var totalBytes: Double?
    var progress: Double?
    weak var progressDelegate: DownloadProgressDelegate?
    weak var delegate: DownloadDelegate?

    
    convenience init(name: String, url: String) {
        self.init()
        self.identifier = name
        self.url = url
    }
}

extension CMDownload: URLSessionDownloadDelegate {
    
    
    func defaultSession() -> Foundation.URLSession {
        let defaultSessionConfig = URLSessionConfiguration.default
        defaultSessionConfig.allowsCellularAccess = false
        defaultSessionConfig.timeoutIntervalForRequest = 60
        defaultSessionConfig.httpMaximumConnectionsPerHost = 4
        let session = Foundation.URLSession(configuration: defaultSessionConfig, delegate: self, delegateQueue: nil)
        return session
    }

    func downloadTaskWithUrl(_ url: String) {
        session = self.defaultSession()
        downloadTask = session!.downloadTask(with: URLRequest(url: URL(string: url)!))
        downloadTask?.resume()
        self.downloadState = DownloadState.downloading
    }
    
    internal func resumeWithIdentifier(_ identifier: String) {
        downloadTask = session!.downloadTask(withResumeData: self.existedData!)
        downloadTask?.resume()
        downloadState = DownloadState.downloading

    }
    
    internal func cancelWithIdentifer(_ identifier: String) {
        downloadTask?.cancel(byProducingResumeData: { (data) -> Void in
            self.existedData = data
        })
        downloadState = DownloadState.suspend
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytes == nil {
            totalBytes = Double(totalBytesExpectedToWrite)
        }
        
        print("\((Double(totalBytesWritten) / totalBytes!))")
        progress = Double(totalBytesWritten) / totalBytes!
        self.progressDelegate?.sendTheProgress(progress!)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finish downloading \(location)")
        downloadState = DownloadState.success
        self.delegate?.urlSessionDownloadFinishDownloading(self)
        let fileManger = FileManager.default
        var savePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        savePath = savePath! + "/\(self.identifier!).mp4"
        print("\(savePath),identifier == \(self.identifier)")
        let saveUrl = URL(fileURLWithPath: savePath!)
        if fileManger.fileExists(atPath: savePath!) {
            try! fileManger.removeItem(at: saveUrl)
        }else{
            try! fileManger.copyItem(at: location, to: saveUrl)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("session did complete with error : \(error?.localizedDescription)")
        
        
        if let error = error as? NSError {
            if error.localizedDescription == "cancelled" {
                downloadState = DownloadState.suspend
            }else if error.localizedDescription == "The network connection was lost." {
                downloadState = DownloadState.suspend
                existedData = error.userInfo["NSURLSessionDownloadTaskResumeData"] as? Data
            }else if error.localizedDescription == "The Internet connection appears to be offline." {
                downloadState = DownloadState.suspend
                existedData = error.userInfo["NSURLSessionDownloadTaskResumeData"] as? Data
            }else {
                downloadState = DownloadState.failed
            }
            
        }else {
            downloadState = DownloadState.finished
        }
        
        self.delegate?.urlSessionDownloadComplete(self, error: error as NSError?)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("fileOffset == \(Double(fileOffset)),expectedTotalBytes == \(Double(expectedTotalBytes))")
    }
    
}
