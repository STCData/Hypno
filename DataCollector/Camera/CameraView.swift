//
//  SimpleCameraView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        ZStack {
            HostedCameraViewController()
            VisionView(visionViewModel: VisionViewModel(visionPool: VisionPool.cameraPool))
        }
        .ignoresSafeArea()
    }
}
