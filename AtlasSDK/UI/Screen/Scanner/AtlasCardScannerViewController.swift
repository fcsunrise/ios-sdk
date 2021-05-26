//
//  AtlasCardScannerViewController.swift
//  AtlasSDK
//
//  Created by Yelyzaveta Kartseva on 12.05.2021.
//

import UIKit
import Vision
import AVFoundation

protocol AtlasCardScannerViewControllerDelegate: class {
    
    func didFindCardNumber(cardNumber: String)
    
}

class AtlasCardScannerViewController: AtlasBaseViewController {
    
    //MARK: - Defaults
    
    private enum Defaults {
        static let imageDetectionQueueName: String = "AtlasCardScannerViewController.image.handling.queue"
    }
    
    //MARK: - Properties
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    private let textRecognitionWorkQueue = DispatchQueue(label: Defaults.imageDetectionQueueName, qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private let requestHandler = VNSequenceRequestHandler()
    private var rectangleDrawing: CAShapeLayer?
    private var paymentCardRectangleObservation: VNRectangleObservation?
    
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    weak var delegate: AtlasCardScannerViewControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVision()
        self.setupCaptureSession()
        self.captureSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func prepareNavigationBar() {
        self.setNavigationBar(isHidden: false)
    }

    //MARK: - Camera
    
    private func setupVision() {
        self.textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }


                detectedText += topCandidate.string
                detectedText += "\n"
            }
            print("Detected text: \(detectedText)")
            DispatchQueue.main.async{
//                self.delegate?.didFindCardNumber(cardNumber: detectedText)
            }
        }

        self.textRecognitionRequest.recognitionLevel = .accurate
    }
    
    private func setupCaptureSession() {
        self.addCameraInput()
        self.addPreviewLayer()
        self.addVideoOutput()
    }
    
    private func addCameraInput() {
        let device = AVCaptureDevice.default(for: .video)!
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func addPreviewLayer() {
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    private func addVideoOutput() {
        self.videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        self.captureSession.addOutput(self.videoOutput)
        guard let connection = self.videoOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
    
    private func detectPaymentCard(frame: CVImageBuffer) -> VNRectangleObservation? {
        let rectangleDetectionRequest = VNDetectRectanglesRequest()
        let paymentCardAspectRatio: Float = 85.60/53.98
        rectangleDetectionRequest.minimumAspectRatio = paymentCardAspectRatio * 0.95
        rectangleDetectionRequest.maximumAspectRatio = paymentCardAspectRatio * 1.10
        
        let textDetectionRequest = VNDetectTextRectanglesRequest()
        
        try? self.requestHandler.perform([rectangleDetectionRequest, textDetectionRequest], on: frame)
        
        guard let rectangle = (rectangleDetectionRequest.results as? [VNRectangleObservation])?.first,
            let text = (textDetectionRequest.results as? [VNTextObservation])?.first,
            rectangle.boundingBox.contains(text.boundingBox) else {
                // no credit card rectangle detected
                return nil
        }
        
        return rectangle
    }
    
    private func createRectangleDrawing(_ rectangleObservation: VNRectangleObservation) -> CAShapeLayer {
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.previewLayer.frame.height)
        let scale = CGAffineTransform.identity.scaledBy(x: self.previewLayer.frame.width, y: self.previewLayer.frame.height)
        let rectangleOnScreen = rectangleObservation.boundingBox.applying(scale).applying(transform)
        let boundingBoxPath = CGPath(rect: rectangleOnScreen, transform: nil)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = boundingBoxPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.borderWidth = 5
        return shapeLayer
    }
    
    private func trackPaymentCard(for observation: VNRectangleObservation, in frame: CVImageBuffer) -> VNRectangleObservation? {
        
        let request = VNTrackRectangleRequest(rectangleObservation: observation)
        request.trackingLevel = .fast
        
        try? self.requestHandler.perform([request], on: frame)
        
        guard let trackedRectangle = (request.results as? [VNRectangleObservation])?.first else {
            return nil
        }
        return trackedRectangle
    }
    
    private func handleObservedPaymentCard(_ observation: VNRectangleObservation, in frame: CVImageBuffer) {
        if let trackedPaymentCardRectangle = self.trackPaymentCard(for: observation, in: frame) {
            DispatchQueue.main.async {
               self.rectangleDrawing?.removeFromSuperlayer()
               self.rectangleDrawing = self.createRectangleDrawing(trackedPaymentCardRectangle)
                self.view.layer.addSublayer(self.rectangleDrawing!)
            }
            DispatchQueue.global(qos: .userInitiated).async {
                if let extractedNumber = self.extractPaymentCardNumber(frame: frame, rectangle: observation) {
                    
                    DispatchQueue.main.async {
                        self.captureSession.removeOutput(self.videoOutput)
                        self.captureSession.stopRunning()
                        self.delegate?.didFindCardNumber(cardNumber: extractedNumber)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            self.paymentCardRectangleObservation = nil
        }
    }
    
    private func extractPaymentCardNumber(frame: CVImageBuffer, rectangle: VNRectangleObservation) -> String? {
        
        let cardPositionInImage = VNImageRectForNormalizedRect(rectangle.boundingBox, CVPixelBufferGetWidth(frame), CVPixelBufferGetHeight(frame))
        let ciImage = CIImage(cvImageBuffer: frame)
        let croppedImage = ciImage.cropped(to: cardPositionInImage)
        
        let stillImageRequestHandler = VNImageRequestHandler(ciImage: croppedImage, options: [:])
        try? stillImageRequestHandler.perform([self.textRecognitionRequest])
        
        guard let texts = self.textRecognitionRequest.results as? [VNRecognizedTextObservation], texts.count > 0 else {
            return nil
        }
        let digitsRecognized = texts
            .flatMap({ $0.topCandidates(10).map({ $0.string }) })
            .map({ $0.replacingOccurrences(of: " ", with: "") })
            .map({ $0.filter("0123456789.".contains) })
        let _16digits = digitsRecognized.first(where: { $0.count == 16 })
        let has16Digits = _16digits != nil
        let _4digits = digitsRecognized.filter({ $0.count == 4 })
        let has4sections4digits = _4digits.count == 4
        
        let digits = _16digits ?? _4digits.joined()
        let digitsIsValid = (has16Digits || has4sections4digits) && self.checkDigits(digits)
        return digitsIsValid ? digits : nil
    }
    
    private func checkDigits(_ digits: String) -> Bool {
        guard digits.count == 16, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: digits)) else {
            return false
        }
        var digits = digits
        let checksum = digits.removeLast()
        let sum = digits.reversed()
            .enumerated()
            .map({ (index, element) -> Int in
                if (index % 2) == 0 {
                   let doubled = Int(String(element))!*2
                   return doubled > 9
                       ? Int(String(String(doubled).first!))! + Int(String(String(doubled).last!))!
                       : doubled
                } else {
                    return Int(String(element))!
                }
            })
            .reduce(0, { (res, next) in res + next })
        let checkDigitCalc = (sum * 9) % 10
        return Int(String(checksum))! == checkDigitCalc
    }
    
}

//MARK: - StoryboardInstantiable
extension AtlasCardScannerViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        return Storyboard.scanner
    }
    
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension AtlasCardScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        DispatchQueue.main.async {
            self.rectangleDrawing?.removeFromSuperlayer() // removes old rectangle drawings
        }
        if let paymentCardRectangleObservation = self.paymentCardRectangleObservation {
            self.handleObservedPaymentCard(paymentCardRectangleObservation, in: frame)
        } else if let paymentCardRectangleObservation = self.detectPaymentCard(frame: frame) {
            self.paymentCardRectangleObservation = paymentCardRectangleObservation
        }
    }
    
}
