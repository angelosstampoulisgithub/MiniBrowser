//
//  WebView.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import SwiftUI
import WebKit

extension Notification.Name {
    static let loadURL = Notification.Name("loadURL")
    static let goBack = Notification.Name("goBack")
    static let goForward = Notification.Name("goForward")
    static let reload = Notification.Name("reload")

    static let showDownloads = Notification.Name("showDownloads")
}

final class WebViewProcessPool {
    static let shared = WKProcessPool()
}

struct WebView: UIViewRepresentable {
    @Binding var tab: BrowserTab
    let userAgent: String
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.processPool = WebViewProcessPool.shared

        let webView = WKWebView(frame: .zero, configuration: config)
        context.coordinator.webView = webView
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = userAgent

        if let url = tab.url {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {

      
        if tab.shouldLoadNewURL, let url = tab.url {
            tab.shouldLoadNewURL = false
            webView.load(URLRequest(url: url))
        }
        
        if tab.goBackTrigger {
            DispatchQueue.main.async { self.tab.goBackTrigger = false }
            webView.goBack()
        }

        if tab.goForwardTrigger {
            DispatchQueue.main.async { self.tab.goForwardTrigger = false }
            webView.goForward()
        }

        if tab.reloadTrigger {
            DispatchQueue.main.async { self.tab.reloadTrigger = false }
            webView.reload()
        }

        if tab.exportAndShowDownloadsTrigger {
            DispatchQueue.main.async { self.tab.exportAndShowDownloadsTrigger = false }
            context.coordinator.exportPDFAndShowDownloads()
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        weak var webView: WKWebView?

        init(_ parent: WebView) {
            self.parent = parent
        }

        func exportPDFAndShowDownloads() {
            guard let webView = webView else { return }

            if #available(iOS 14.0, *) {
                let config = WKPDFConfiguration()

                webView.createPDF(configuration: config) { result in
                    switch result {
                    case .success(let data):
                        do {
                            let fileURL = try PDFManager.shared.savePDF(data)
                            print("PDF saved:", fileURL)

                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: .showDownloads, object: nil)
                            }

                        } catch {
                            print("Save error:", error)
                        }

                    case .failure(let error):
                        print("PDF error:", error)
                    }
                }
            }
        }

        func exportPDF() {
            guard let webView = webView else { return }

            if #available(iOS 14.0, *) {
                let config = WKPDFConfiguration()
                webView.createPDF(configuration: config) { result in
                    switch result {
                    case .success(let data):
                        self.savePDF(data)
                    case .failure(let error):
                        print("PDF error:", error)
                    }
                }
            }
        }

        private func savePDF(_ data: Data) {
            do {
                let fileURL = try PDFManager.shared.savePDF(data)
                print("PDF saved at:", fileURL.path)

                DispatchQueue.main.async {
                    self.presentShareSheet(url: fileURL)
                }
            } catch {
                print("Save error:", error)
            }
        }

        private func presentShareSheet(url: URL) {
            guard let root = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows.first?.rootViewController else { return }

            let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            root.present(av, animated: true)
        }
       
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let urlString = webView.url?.absoluteString ?? ""
            print("url=",urlString)
            DispatchQueue.main.async {
                self.parent.tab.title = webView.title ?? self.parent.tab.url?.host ?? "Untitled"
                self.parent.tab.canGoBack = webView.canGoBack
                self.parent.tab.canGoForward = webView.canGoForward
                self.parent.tab.url = URL(string:urlString)
                self.parent.tab.urlString = urlString
                

                
            }
        }
    }
}
