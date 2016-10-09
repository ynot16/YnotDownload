//
//  DownloadCenterViewController.swift
//  YnotDownload
//
//  Created by bori－applepc on 16/3/4.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class DownloadCenterViewController: UIViewController {

    var tableView: UITableView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Window.SCREENWIDTH, height: Window.SCREENHIEGHT), style: .plain)
        tableView!.dataSource = self;
        tableView!.delegate = self;
        tableView?.register(UINib(nibName: "DownloadTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell Identifier")
        view.addSubview(tableView!)
        // Do any additional setup after loading the view.
    }
}

// MARK: TableView 代理和数据源

extension DownloadCenterViewController: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YnotDownloadManager.sharedInstance.downloadArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Cell Identifier"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DownloadTableViewCell {
            
            let downloadModel = YnotDownloadManager.sharedInstance.downloadArray[(indexPath as NSIndexPath).row]
            
            let course = Course(url: downloadModel.url!,name: downloadModel.identifier!)
            
            cell.nameLabel.text = course.name
            
            /*
            通过返回对应的cmDownload对象，设置代理对象
            */
            let cmDownload = YnotDownloadManager.sharedInstance.getTheSpecficCMDownload(downloadModel.identifier!)
            cmDownload.progressDelegate = cell
            cmDownload.delegate = self
            
            //下载完成更新UI
            if cmDownload.downloadState == DownloadState.finished {
                cell.downloadProgress.isHidden = true
                cell.downloadButton.setTitle("Done", for: UIControlState())
                cell.downloadButton.setImage(nil, for: UIControlState())
                cell.downloadPercent.text = "100%"
            }
            
            
            //下载的闭包
            cell.downloadAction = {(selected: Bool) in
                YnotDownloadManager.sharedInstance.downloadWithCMDownload(course)
            }
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: 下载代理

extension DownloadCenterViewController: DownloadDelegate {
    
    func urlSessionDownloadComplete(_ cmDownload: CMDownload, error: NSError?) {
        //回到主线程更新UI
        DispatchQueue.main.async { () -> Void in
            self.tableView?.reloadData()
        }
        
        print("name = \(cmDownload.identifier),error = \(error?.localizedDescription)")
    }
    
    func urlSessionDownloadFinishDownloading(_ cmDownload: CMDownload) {
        print("finsih downloading \(cmDownload.identifier)")
    }
}

struct Window {
    static let SCREENWIDTH = UIScreen.main.bounds.width
    static let SCREENHIEGHT = UIScreen.main.bounds.height
}
