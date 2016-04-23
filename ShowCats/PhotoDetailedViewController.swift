//
//  PhotoDetailedViewController.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class PhotoDetailedViewController: UIViewController {

    var photo:Photo!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imageView.sd_setImageWithURL(NSURL(string: photo.largeImageLink)!,
                                     placeholderImage: nil,
                                     options: [.ProgressiveDownload])
    }

}
