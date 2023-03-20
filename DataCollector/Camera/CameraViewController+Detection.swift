//
//  CameraViewController+Detection.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import AVFoundation
import Logging
import UIKit
import Vision

private let log = LogLabels.camera.makeLogger()

extension CameraViewController {
    func setupDetector() {
        if let yoloWorker = try? YOLOObjectRecognizer() {
            visionPool = VisionPool(workers: [yoloWorker])
            visionPool?.observationsSubject
                .receive(on: RunLoop.main)
                .sink { observations in
                    self.extractDetections(observations)

                }.store(in: &visionSubscriptions)
        }
    }

    func detectionDidComplete(request: VNRequest, error _: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }

    func draw(objectObservation: VNRecognizedObjectObservation) {
        // Transformations
        let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
        let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)

        if let firstObservation = objectObservation.labels.first {
            log.info("📷 \(objectObservation.boundingBox.origin.x)  \(firstObservation.confidence) \(firstObservation.identifier)")
        }
        let boxLayer = drawBoundingBox(transformedBounds)

        detectionLayer.addSublayer(boxLayer)
    }

    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil

        for observation in results where observation is VNRecognizedObjectObservation {
            if let objObservation = observation as? VNRecognizedObjectObservation {
                draw(objectObservation: objObservation)
            } else {
                continue
            }
        }
    }

    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }

    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor(red: 0.9, green: 0.1, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        return boxLayer
    }

    func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from _: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        visionPool?.receive(pixelBuffer)
    }
}
