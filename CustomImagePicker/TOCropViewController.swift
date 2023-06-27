//
//  TOCropViewController.swift
//  CustomImagePicker
//
//  Created by R.Unnikrishnan on 27/06/23.
//

import UIKit
import CropViewController

class TOCropViewController: UIViewController,CropViewControllerDelegate {
   var CropArray : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCropViewController()
        
    }
    func presentCropViewController()
    {
        let image: UIImage = CropArray[0] //Load an image
        let cropViewController = CropViewController(croppingStyle: .circular,  image: image)
        cropViewController.delegate = self
        cropViewController.showActivitySheetOnDone = true
        present(cropViewController, animated: true, completion: nil)
        
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        // Use the cropped image as desired
//        imageView.image = image
    }
    private func cropViewController(_ cropViewController: TOCropViewController?, didCropToCircularImage image: UIImage?, with cropRect: CGRect, angle: Int) {
//        imageView.image = image
    }
    
}

