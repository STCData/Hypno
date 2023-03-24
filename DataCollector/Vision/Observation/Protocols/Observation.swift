//
//  Observation.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation
import Vision

enum Observation {
    case humanHandPose(HumanHandPoseObservation)
    case barcode(BarcodeObservation)
    case recognizedText(RecognizedTextObservation)
    case face(FaceObservation)
    case recognizedObject(RecognizedObjectObservation)
    case recognizedPoints(RecognizedPointsObservation)
    case rectangle(RectangleObservation)
    case detectedObject(DetectedObjectObservation)
}

extension Observation: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()

        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "humanHandPose":
            let observation = try singleContainer.decode(HumanHandPoseObservation.self)
            self = .humanHandPose(observation)
        case "barcode":
            let observation = try singleContainer.decode(BarcodeObservation.self)
            self = .barcode(observation)
        case "recognizedText":
            let observation = try singleContainer.decode(RecognizedTextObservation.self)
            self = .recognizedText(observation)
        case "face":
            let observation = try singleContainer.decode(FaceObservation.self)
            self = .face(observation)
        case "recognizedObject":
            let observation = try singleContainer.decode(RecognizedObjectObservation.self)
            self = .recognizedObject(observation)
        case "recognizedPoints":
            let observation = try singleContainer.decode(RecognizedPointsObservation.self)
            self = .recognizedPoints(observation)
        case "rectangle":
            let observation = try singleContainer.decode(RectangleObservation.self)
            self = .rectangle(observation)
        case "detectedObject":
            let observation = try singleContainer.decode(DetectedObjectObservation.self)
            self = .detectedObject(observation)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown type of content.")
        }
    }

    func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case let .humanHandPose(observation):
            try singleContainer.encode(observation)
        case let .barcode(observation):
            try singleContainer.encode(observation)
        case let .recognizedText(observation):
            try singleContainer.encode(observation)
        case let .face(observation):
            try singleContainer.encode(observation)
        case let .recognizedObject(observation):
            try singleContainer.encode(observation)
        case let .recognizedPoints(observation):
            try singleContainer.encode(observation)
        case let .rectangle(observation):
            try singleContainer.encode(observation)
        case let .detectedObject(observation):
            try singleContainer.encode(observation)
        }
    }

    static func from(_ vnObservation: VNObservation) -> Observation {
        switch vnObservation {
        case let handObservation as VNHumanHandPoseObservation:
            return .humanHandPose(HumanHandPoseObservation(humanHandPoseObservation: handObservation))
        case let barcodeObservation as VNBarcodeObservation:
            return .barcode(BarcodeObservation(barcodeObservation: barcodeObservation))
        case let faceObservation as VNFaceObservation:
            return .face(FaceObservation(faceObservation: faceObservation))
        case let textObservation as VNRecognizedTextObservation:
            return .recognizedText(RecognizedTextObservation(textObservation: textObservation))
        case let objectObservation as VNRecognizedObjectObservation:
            return .recognizedObject(RecognizedObjectObservation(recognizedObjectObservation: objectObservation))
        case let pointsObservation as VNRecognizedPointsObservation:
            return .recognizedPoints(RecognizedPointsObservation(recognizedPointsObservation: pointsObservation))
        case let rectangleObservation as VNRectangleObservation:
            return .rectangle(RectangleObservation(rectangleObservation: rectangleObservation))
        case let detectedObjectObservation as VNDetectedObjectObservation:
            return .detectedObject(DetectedObjectObservation(detectedObjectObservation: detectedObjectObservation))
        default:
            fatalError("Unknown observation")
        }
    }
}

protocol ObservationProtocol {
    var timestamp: Date { get set }
    var confidence: Double { get set }
}
