//
//  ImageViewController.swift
//  CustomImagePicker
//
//  Created by R.Unnikrishnan on 26/06/23.
//

import UIKit

class ImageViewController: UIViewController {
    var capturedImages: [UIImage] = []
    var image : UIImage?

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.image = capturedImages[0]
        imageView.image = capturedImages[0]
        
    }
}
