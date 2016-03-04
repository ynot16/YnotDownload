//
//  CMDownload.swift
//  pratice
//
//  Created by bori－applepc on 16/2/3.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import Foundation

protocol DownloadProgressDelegate: class {
    func sendTheProgress(progress: Double)
}


protocol DownloadDelegate: class {
    func urlSessionDownloadFinishDownloading(cmDownload: CMDownload)
    func urlSessionDownloadComplete(cmDownload: CMDownload, error: NSError?)
}

enum DownloadState {
    case Downloading
    case Cancel
    case Suspend
    case Finished
    case Failed
    case Success
}

class CMDownload: NSObject {
    var identifier: String?
    var url: String?
    var existedData: NSData?
    var downloadTask: NSURLSessionDownloadTask?
    var session: NSURLSession?
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

extension CMDownload: NSURLSessionDownloadDelegate {
    
    
    func defaultSession() -> NSURLSession {
        let defaultSessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        defaultSessionConfig.allowsCellularAccess = false
        defaultSessionConfig.timeoutIntervalForRequest = 60
        defaultSessionConfig.HTTPMaximumConnectionsPerHost = 4
        let session = NSURLSession(configuration: defaultSessionConfig, delegate: self, delegateQueue: nil)
        return session
    }

    func downloadTaskWithUrl(url: String) {
        session = self.defaultSession()
        downloadTask = session!.downloadTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!))
        downloadTask?.resume()
        self.downloadState = DownloadState.Downloading
    }
    
    internal func resumeWithIdentifier(identifier: String) {
        downloadTask = session!.downloadTaskWithResumeData(self.existedData!)
        downloadTask?.resume()
        downloadState = DownloadState.Downloading

    }
    
    internal func cancelWithIdentifer(identifier: String) {
        downloadTask?.cancelByProducingResumeData({ (data) -> Void in
            self.existedData = data
        })
        downloadState = DownloadState.Suspend
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytes == nil {
            totalBytes = Double(totalBytesExpectedToWrite)
        }
        
        print("\((Double(totalBytesWritten) / totalBytes!))")
        progress = Double(totalBytesWritten) / totalBytes!
        self.progressDelegate?.sendTheProgress(progress!)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("finish downloading \(location)")
        downloadState = DownloadState.Success
        self.delegate?.urlSessionDownloadFinishDownloading(self)
        let fileManger = NSFileManager.defaultManager()
        var savePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        savePath = savePath!.stringByAppendingString("/\(self.identifier!).mp4")
        print("\(savePath),identifier == \(self.identifier)")
        let saveUrl = NSURL(fileURLWithPath: savePath!)
        if fileManger.fileExistsAtPath(savePath!) {
            try! fileManger.removeItemAtURL(saveUrl)
        }else{
            //            do {
            //                try fileManger.copyItemAtURL(location, toURL: saveUrl)
            //            }catch  {
            //                print(error)
            //            }
            try! fileManger.copyItemAtURL(location, toURL: saveUrl)
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("session did complete with error : \(error?.localizedDescription)")
        
        
        if let error = error {
            if error.localizedDescription == "cancelled" {
                downloadState = DownloadState.Suspend
            }else if error.localizedDescription == "The network connection was lost." {
                downloadState = DownloadState.Suspend
                existedData = error.userInfo["NSURLSessionDownloadTaskResumeData"] as? NSData
            }else if error.localizedDescription == "The Internet connection appears to be offline." {
                downloadState = DownloadState.Suspend
                existedData = error.userInfo["NSURLSessionDownloadTaskResumeData"] as? NSData
            }else {
                downloadState = DownloadState.Failed
            }
            
        }else {
            downloadState = DownloadState.Finished
        }
        
        self.delegate?.urlSessionDownloadComplete(self, error: error)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("fileOffset == \(Double(fileOffset)),expectedTotalBytes == \(Double(expectedTotalBytes))")
    }
    
}
