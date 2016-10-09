//
//  DownloadTableViewCell.swift
//  pratice
//
//  Created by bori－applepc on 16/1/30.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class DownloadTableViewCell: UITableViewCell {

    typealias DownloadActionClousre = (_ selected: Bool) -> ()
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var downloadPercent: UILabel!
    var downloadAction: DownloadActionClousre?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadButton(_ sender: AnyObject) {
        self.downloadButton.isSelected = !self.downloadButton.isSelected
        if let downloadA = downloadAction {
            downloadA((sender as! UIButton).isSelected)
        }
    }
}

extension DownloadTableViewCell: DownloadProgressDelegate {
    func sendTheProgress(_ progress: Double) {
        DispatchQueue.main.async {
            self.downloadProgress.setProgress(Float(progress), animated: true)
            self.downloadPercent.text = String(format: "%.2f%%", progress * 100.00)
        }
    }
}
