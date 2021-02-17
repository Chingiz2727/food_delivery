import AVFoundation
protocol CameraMetadataOutput {
    typealias QrScanned = (String) -> Void

    var qrScanned: QrScanned? { get set }
}

final class CameraMetadaOutputDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate, CameraMetadataOutput {
    var qrScanned: QrScanned?

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        if object.type == .qr {
            guard let objectString = object.stringValue else { return }
            self.qrScanned?(objectString)
        }
    }
}
