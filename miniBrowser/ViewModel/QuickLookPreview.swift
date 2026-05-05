//
//  QuickLookPreview.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 6/5/26.
//

import Foundation
import SwiftUI
import QuickLook


struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UINavigationController {
        let preview = QLPreviewController()
        preview.dataSource = context.coordinator

        preview.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: context.coordinator,
            action: #selector(Coordinator.dismissPreview)
        )

        let nav = UINavigationController(rootViewController: preview)
        return nav
    }

    func updateUIViewController(_ controller: UINavigationController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url, dismiss: dismiss)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL
        let dismiss: DismissAction

        init(url: URL, dismiss: DismissAction) {
            self.url = url
            self.dismiss = dismiss
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController,
                               previewItemAt index: Int) -> QLPreviewItem {
            url as QLPreviewItem
        }

        @objc func dismissPreview() {
            dismiss()
        }
    }
}
