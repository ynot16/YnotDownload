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
        
        view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: CGRectMake(0, 0, Window.SCREENWIDTH, Window.SCREENHIEGHT), style: .Plain)
        tableView!.dataSource = self;
        tableView!.delegate = self;
        tableView?.registerNib(UINib(nibName: "DownloadTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "Cell Identifier")
        view.addSubview(tableView!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: TableView 代理和数据源

extension DownloadCenterViewController: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YnotDownloadManager.sharedInstance.downloadArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "Cell Identifier"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? DownloadTableViewCell {
            
            let downloadModel = YnotDownloadManager.sharedInstance.downloadArray[indexPath.row]
            
            let course = Course(url: downloadModel.url!,name: downloadModel.identifier!)
            
            cell.nameLabel.text = course.name
            
            /*
            通过返回对应的cmDownload对象，设置代理对象
            */
            let cmDownload = YnotDownloadManager.sharedInstance.getTheSpecficCMDownload(downloadModel.identifier!)
            cmDownload.progressDelegate = cell
            cmDownload.delegate = self
            
            //下载完成更新UI
            if cmDownload.downloadState == DownloadState.Finished {
                cell.downloadProgress.hidden = true
                cell.downloadButton.setTitle("Done", forState: .Normal)
                cell.downloadButton.setImage(nil, forState: .Normal)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: 下载代理

extension DownloadCenterViewController: DownloadDelegate {
    
    func urlSessionDownloadComplete(cmDownload: CMDownload, error: NSError?) {
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView?.reloadData()
        }
        
        print("name = \(cmDownload.identifier),error = \(error?.localizedDescription)")
    }
    
    func urlSessionDownloadFinishDownloading(cmDownload: CMDownload) {
        print("finsih downloading \(cmDownload.identifier)")
    }
}

struct Window {
    static let SCREENWIDTH = UIScreen.mainScreen().bounds.width
    static let SCREENHIEGHT = UIScreen.mainScreen().bounds.height
}
