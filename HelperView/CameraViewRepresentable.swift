//
//  CameraView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI
import AVFoundation

@available(iOS 18.0, *)
struct CameraViewRepresentable: UIViewControllerRepresentable {
    let viewModel: CameraManager
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - UIViewController for Camera Feed
@available(iOS 18.0, *)
class CameraViewController: UIViewController {
    var viewModel: CameraManager!
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer.session = viewModel.captureSession
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        Task{
            await viewModel.start()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
}
