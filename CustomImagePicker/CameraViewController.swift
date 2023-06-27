//
//  CameraViewController.swift
//  CustomImagePicker
//
//  Created by R.Unnikrishnan on 26/06/23.
//


import UIKit
import AVFoundation
import Vision
import RSKImageCropperSwift
import CropViewController

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imageView: UIImageView!
    var circleView: UIView!
    var captureButton: UIButton!
    var capturedImages: [UIImage] = []
    var capturedImage: UIImage?
    var croppedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera)
        else
        {
            print("Unable to access the front camera")
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        let photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            captureButton?.isHidden = true
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        let circleSize: CGFloat = 300.0 // Adjust the size of the circle as needed
        
        circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleSize, height: circleSize))
        circleView.center = view.center
        circleView.backgroundColor = UIColor.clear // Set background color to clear
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = circleView.bounds
        
        let outerPath = UIBezierPath(rect: circleView.bounds)
        let innerPath = UIBezierPath(ovalIn: circleView.bounds)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.cgColor // Set mask background color to black
        
        circleView.layer.mask = maskLayer
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: circleSize, height: circleSize))
        imageView.contentMode = .scaleAspectFill
        imageView.center = circleView.center
        imageView.layer.masksToBounds = true // Apply circular mask
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        view.addSubview(circleView)
        view.addSubview(imageView)
        
        
        
        let captureButton = UIButton(type: .custom)
        captureButton.setTitle("Capture", for: .normal)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.backgroundColor = .black
        captureButton.frame = CGRect(x: 20, y: view.bounds.height - 150, width: 100, height: 40) // Updated x-coordinate to 20 for left alignment
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        
        let useButton = UIButton(type: .custom)
        useButton.setTitle("Use Image", for: .normal)
        useButton.setTitleColor(.white, for: .normal)
        useButton.backgroundColor = .black
        useButton.frame = CGRect(x: view.bounds.width - 120, y: view.bounds.height - 150, width: 100, height: 40) // Updated x-coordinate for right alignment
        useButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        
        view.addSubview(circleView)
        view.addSubview(captureButton)
        
        
    }
    
    @objc func captureButtonTapped() {
        guard let photoOutput = captureSession.outputs.first as? AVCapturePhotoOutput
        else
        {
            captureButton?.isHidden = true
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let TOCropViewController = storyBoard.instantiateViewController(withIdentifier: "TOCropViewController") as! TOCropViewController
        TOCropViewController.CropArray = capturedImages
        self.navigationController?.pushViewController(TOCropViewController, animated: true)
        
        
        // Create and add the useButton as a subview
        let useButton = UIButton(type: .custom)
        useButton.setTitle("Use Image", for: .normal)
        useButton.setTitleColor(.white, for: .normal)
        useButton.backgroundColor = .black
        useButton.frame = CGRect(x: (view.bounds.width - 100) / 2, y: view.bounds.height - 150, width: 100, height: 40)
        useButton.addTarget(self, action: #selector(useButtonTapped), for: .touchUpInside)
        view.addSubview(useButton)
    }
    
    @objc func useButtonTapped() {
        //        cropImage()
        
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let jumpToPage = storyBoard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        jumpToPage.capturedImages = capturedImages
        self.navigationController?.pushViewController(jumpToPage, animated: true)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
           let image = UIImage(data: imageData) {
            capturedImages.append(image)
            imageView.image = image
            imageView.alpha = 1.0
            //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //            let imageViewController = storyBoard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            // Pass the captured image to the ImageViewController
            
            
            
        }
        //
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        circleView.center = CGPoint(x: circleView.center.x + translation.x, y: circleView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.view != nil else { return }
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
            gesture.scale = 1.0
        }
    }
    func createCircularMask(for frame: CGRect) -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: frame)
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        return maskLayer
    }
    
//    func cropImage() {
//        guard let capturedImage = capturedImage else {
//            return
//        }
//        
//        let scale = capturedImage.size.width / previewLayer.bounds.width
//        let circleFrame = circleView.convert(circleView.bounds, to: previewLayer as! UICoordinateSpace)
//        let circleRect = CGRect(x: circleFrame.origin.x * scale,
//                                y: circleFrame.origin.y * scale,
//                                width: circleFrame.size.width * scale,
//                                height: circleFrame.size.height * scale)
//        
//        if let cgImage = capturedImage.cgImage?.cropping(to: circleRect) {
//            croppedImage = UIImage(cgImage: cgImage)
//        }
//    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = view.bounds
    }
    
    //    func performFaceRecognition(image: UIImage) {
    //        guard let ciImage = CIImage(image: image) else {
    //            return
    //        }
    //
    //        let faceRequest = VNDetectFaceRectanglesRequest { [weak self] (request, error) in
    //            guard let observations = request.results as? [VNFaceObservation] else {
    //                return
    //            }
    //
    //            for observation in observations {
    //                let boundingBox = observation.boundingBox
    //                let imageSize = image.size
    //                let faceBoundingBox = CGRect(x: boundingBox.origin.x * imageSize.width,
    //                                             y: (1 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height,
    //                                             width: boundingBox.size.width * imageSize.width,
    //                                             height: boundingBox.size.height * imageSize.height)
    //
    //                let roundBoxLayer = CAShapeLayer()
    //                roundBoxLayer.path = UIBezierPath(ovalIn: faceBoundingBox).cgPath
    //                roundBoxLayer.lineWidth = 2.0
    //                roundBoxLayer.strokeColor = UIColor.red.cgColor
    //                roundBoxLayer.fillColor = UIColor.clear.cgColor
    //
    //                self?.circleView.layer.addSublayer(roundBoxLayer)
    //            }
    //        }
    //
    //        let faceRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
    //        do {
    //            try faceRequestHandler.perform([faceRequest])
    //        } catch {
    //            print("Face detection error: \(error)")
    //        }
    //    }
}


