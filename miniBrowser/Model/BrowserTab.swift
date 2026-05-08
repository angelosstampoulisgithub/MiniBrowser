//
//  BrowserTab.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import WebKit

struct BrowserTab: Identifiable {
    let id = UUID()

    var url: URL?
    var urlString: String = ""
    var title: String = "New Tab"

    var canGoBack = false
    var canGoForward = false

    var goBackTrigger = false
    var goForwardTrigger = false
    var reloadTrigger = false
    var exportAndShowDownloadsTrigger = false

    var shouldLoadNewURL = false
    
    var isBookmarked = false
    
    
    var isLoading = false
    
    var isTyping = false
   
}
