//
//  SimpleCameraView.swift
//  DataCollector
//
//  Created by standard on 3/18/23.
//

import CameraView
import SwiftUI

struct CameraView: View {
    var body: some View {
        HostedCameraViewController()
            .ignoresSafeArea()
    }
}