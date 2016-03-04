//
//  DownloadTableViewCell.swift
//  pratice
//
//  Created by bori－applepc on 16/1/30.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

    typealias DownloadActionClousre = (selected: Bool) -> ()
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var downloadPercent: UILabel!
    var downloadAction: DownloadActionClousre?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.whiteColor()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadButton(sender: AnyObject) {
        self.downloadButton.selected = !self.downloadButton.selected
        if let downloadA = downloadAction {
            downloadA(selected: (sender as! UIButton).selected)
        }
    }
}

extension DownloadTableViewCell: DownloadProgressDelegate {
    func sendTheProgress(progress: Double) {
        dispatch_async(dispatch_get_main_queue()) {
            self.downloadProgress.setProgress(Float(progress), animated: true)
            self.downloadPercent.text = String(format: "%.2f%%", progress * 100.00)
        }
    }
}
