//
//  ViewControllerWrapper.swift
//
//
//  Created by Daniel Bond on 08.12.2025.
//

import SwiftUI

extension UIView {
    func asPreview() -> some View {
        ViewWrapper(view: self)
    }
}

extension UIViewController {
    func asPreview() -> some View {
        ViewControllerWrapper(controller: self)
    }
}

struct ViewWrapper: UIViewRepresentable {
    
    let view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
}
