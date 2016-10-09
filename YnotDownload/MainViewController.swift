//
//  MainViewController.swift
//  YnotDownload
//
//  Created by bori－applepc on 16/3/4.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var urlArray: [String]?
    var titleArray = ["test1","test2","test3","test4","test5","test6","test7"]
    var downloadClick: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //download url
        downloadClick = 0
        let url1 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url2 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url3 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url4 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url5 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url6 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        let url7 = "http://mw5.dwstatic.com/2/4/1529/134981-99-1436844583.mp4"
        urlArray = [url1,url2,url3,url4,url5,url6,url7]
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
}


extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Study Cell") {
            let downloadButton: UIButton = cell.viewWithTag(101) as! UIButton
            downloadButton.addTarget(self, action: #selector(MainViewController.downloadAction(_:)), for: .touchUpInside)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func downloadAction(_ sender: UIButton) {
        guard downloadClick < 7 else {
            print("download click is more than 7")
            return
        }
        print("begin download")
        
        
        /*
        将下载的url和name封装成Course结构
        */
        let course = Course(url: urlArray![downloadClick!], name: titleArray[downloadClick!])
        YnotDownloadManager.sharedInstance.downloadWithCMDownload(course)
        
        downloadClick! += 1
    }
    
}


