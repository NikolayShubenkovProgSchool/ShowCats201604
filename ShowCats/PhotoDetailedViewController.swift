//
//  PhotoDetailedViewController.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class PhotoDetailedViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var photo:Photo!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Для зума нужны 2 момента:
        //1. Задать разные иминимальный и максимальный размеры для масштаба (zoom)
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 4
        //2. Нужно стать делегатом scrollView и переопределить метод
        // viewForZooming у скроллвью
        scrollView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imageView.sd_setImageWithURL(NSURL(string: photo.largeImageLink)!,
                                     placeholderImage: nil,
                                     options: [.ProgressiveDownload])
    }
}

//Чтобы заработало масштабирование, нужно переопределить 
//viewForZoomingInScroolView
extension PhotoDetailedViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
