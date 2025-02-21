////
////  CameraView.swift
////  Purine Help
////
////  Created by 涂庭鋆 on 2025/2/18.
////
//
import SwiftUI
import AVFoundation

struct CameraViewRepresentable: UIViewControllerRepresentable {
    let viewModel: VideoViewModel
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - UIViewController for Camera Feed
class CameraViewController: UIViewController {
    var viewModel: VideoViewModel!
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer.session = viewModel.session
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        viewModel.startCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
}
