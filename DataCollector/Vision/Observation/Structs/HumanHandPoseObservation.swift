//
//  HumanHandPoseObservation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

struct HumanHandPoseObservation: RecognizedPointsObservationProtocol, Codable {
    var timestamp: Date
    var confidence: Double
    var recognizedPoints: [VNRecognizedPointKey: ObservationPoint]

    init(humanHandPoseObservation: VNHumanHandPoseObservation, denormalizeFor: CGSize) {
        timestamp = Date()
        confidence = Double(humanHandPoseObservation.confidence)
        recognizedPoints = RecognizedPointsFrom(recognizedPointsObservation: humanHandPoseObservation, denormalizeFor: denormalizeFor)
    }
}

extension HumanHandPoseObservation: NaturalLanguageDescribable {
    var naturalLanguageClass: String {
        "Hand Pose"
    }

    var naturalLanguageDescription: String {
        NaturalLanguageDescribe(self)!
    }
}