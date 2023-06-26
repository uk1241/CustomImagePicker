//
//  ViewController.swift
//  CustomImagePicker
//
//  Created by R.Unnikrishnan on 26/06/23.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput?

    
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet var cameraBtn: UIButton!
    @IBOutlet var imagePickerBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var uploadImageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Make the image view circular
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        uploadImageView.isHidden = true
        //to give corder radius at the right top of the view
        uploadImageView.clipsToBounds = true
        uploadImageView.layer.cornerRadius = 24
        uploadImageView.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    @IBAction func imagePickerBtnAction(_ sender: UIButton)
    {
        // Toggle the visibility of the views
        let isHidden = uploadImageView.isHidden
        uploadImageView.isHidden = !isHidden
        // Define the initial and final positions for the animation
        let initialYPosition = self.view.frame.height
        let finalYPosition = self.view.frame.height - uploadImageView.frame.height
        // Set the initial position of the views
        uploadImageView.frame.origin.y = initialYPosition
        // Perform the animation
        UIView.animate(withDuration: 0.3) {
            self.uploadImageView.frame.origin.y = isHidden ? finalYPosition : initialYPosition
        }
    }
    
    @IBAction func camerabtnAction(_ sender: UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let jumpToPage = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(jumpToPage, animated: true)
       
    }
}



