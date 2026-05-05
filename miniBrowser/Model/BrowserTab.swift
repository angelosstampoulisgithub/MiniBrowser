//
//  BrowserTab.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import WebKit

class BrowserTab: ObservableObject, Identifiable {
    let id = UUID()
    @Published var url: URL?
    @Published var urlString: String
    @Published var title: String = "New Tab"

    @Published var canGoBack = false
    @Published var canGoForward = false

    @Published var goBackTrigger = false
    @Published var goForwardTrigger = false
    @Published var reloadTrigger = false
    
    @Published var exportAndShowDownloadsTrigger = false

    init(url: URL?) {
        self.url = url
        self.urlString = url?.absoluteString ?? ""
    }
}
