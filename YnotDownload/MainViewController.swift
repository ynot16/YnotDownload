//
//  MainViewController.swift
//  YnotDownload
//
//  Created by bori－applepc on 16/3/4.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var urlArray: [String]?
    var titleArray = ["test1","test2","test3","test4","test5","test6","test7"]
    var downloadClick: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadClick = 0
        let url1 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B3D2A707A-FA3C-4685-BE60-489AFA7ECA85%7D.mp4"
        let url2 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        let url3 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        let url4 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        let url5 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        let url6 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        let url7 = "http://58.67.144.49:7001/ZXMobileELearning//WebFiles/cwFiles/%7B4EC575D9-31BC-4ABC-8034-5EF7665607E8%7D.mp4"
        urlArray = [url1,url2,url3,url4,url5,url6,url7]
        
        tableView.dataSource = self
        tableView.delegate = self
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


extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Study Cell") {
            let downloadButton: UIButton = cell.viewWithTag(101) as! UIButton
            downloadButton.addTarget(self, action: "downloadAction:", forControlEvents: .TouchUpInside)
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func downloadAction(sender: UIButton) {
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
        
        downloadClick!++
    }
    
}


