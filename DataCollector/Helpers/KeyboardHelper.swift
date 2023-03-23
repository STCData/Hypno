//
//  KeyboardHelper.swift
//  DataCollector
//
//  Created by standard on 3/19/23.
//

import Combine
import SwiftUI

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        #if os(iOS)
            GeometryReader { geometry in
                content
                    .padding(.bottom, self.currentHeight)
                    .onAppear(perform: {
                        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                            .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                            .compactMap { notification in
                                withAnimation(.easeOut(duration: 0.16)) {
                                    notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                                }
                            }
                            .map { rect in
                                rect.height - geometry.safeAreaInsets.bottom
                            }
                            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

                        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                            .compactMap { _ in
                                CGFloat.zero
                            }
                            .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                    })
            }
        #else
            content
        #endif
    }
}

extension View {
    func adaptsToKeyboard() -> some View {
        return modifier(AdaptsToKeyboard())
    }
}
