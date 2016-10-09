//
//  YnotDownloadManager.swift
//  pratice
//
//  Created by bori－applepc on 16/2/25.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

struct Course {
    var url: String
    var name: String
}


class YnotDownloadManager: NSObject {
    
    static let sharedInstance = YnotDownloadManager()
    
    fileprivate override init() {
        
    }
    
    var downloadArray = [CMDownload]()
    
    
    
    /*
    判断是否已经已存在该下载对象
    */
    func isExistedDownload(_ course: Course) -> Bool {
        
        guard self.downloadArray.count > 0 else {
            return false
        }
        
        for cmDownload in self.downloadArray {
            if cmDownload.identifier == course.name {
                return true
            }
        }
        return false
    }
    
    
    /*
    根据名称返回对应的CMDownload对象
    */
    func getTheSpecficCMDownload(_ name: String) -> CMDownload {
        
        guard downloadArray.count > 0 else {
            return CMDownload()
        }
        
        for cmDownload in downloadArray {
            if cmDownload.identifier == name {
                return cmDownload
            }
        }
        return CMDownload()
    }

}

extension YnotDownloadManager {
    
    /*
    开放统一一个接口，供用户调用。
    */
    func downloadWithCMDownload(_ course: Course) {
        
        let isExistedDownload = self.isExistedDownload(course)
        
        if isExistedDownload {
            
            for cmDownload in self.downloadArray {
                if cmDownload.identifier == course.name {
                    if let downloadSate = cmDownload.downloadState {
                        switch downloadSate {
                        case .downloading : self.cancel(cmDownload.identifier!)
                        case .suspend : self.resume(cmDownload.identifier!)
                        default: print("Nothing happenes")
                        }
                    }
                }
            }
            
        }else {
            
            self.downloadSessionWithUrl(course.url, name: course.name)
            
        }
    }
    
    
    //开始下载
    fileprivate func downloadSessionWithUrl(_ url: String, name: String) {
        let cmDownload = CMDownload(name: name, url: url)
        downloadArray.append(cmDownload)
        cmDownload.downloadTaskWithUrl(url)
    }
    
    //暂停下载
    fileprivate func cancel(_ name: String) {
        for cmDownload in downloadArray {
            if cmDownload.identifier == name {
                cmDownload.cancelWithIdentifer(name)
            }
        }
    }
    
    //恢复下载
    fileprivate func resume(_ name: String) {
        for cmDownload in downloadArray {
            if cmDownload.identifier == name {
                cmDownload.resumeWithIdentifier(name)
            }
        }
    }
}
