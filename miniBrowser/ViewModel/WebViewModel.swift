//
//  MiniBrowserViewModel.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import WebKit
// MARK: - ViewModel

class WebViewModel: ObservableObject {
    @Published var tabs: [BrowserTab] = [
        BrowserTab(url: URL(string: "https://apple.com")!)
    ]
    @Published var selectedTabID: UUID?
    
    @Published var bookmarks: [Bookmark] = []
    
    @Published var didInitialSync = false
    
    @Published var showBookmarks = false
    
    
    init() {
           let first = BrowserTab(url: URL(string: "https://apple.com")!)
           self.tabs = [first]
           self.selectedTabID = first.id
    }
    
    func addTab() {
        let newTab = BrowserTab(url: URL(string: "https://google.com"))
        tabs.append(newTab)
        selectedTabID = newTab.id
    }
    
    func closeTab(_ tab: BrowserTab) {
        tabs.removeAll { $0.id == tab.id }
        selectedTabID = tabs.first?.id
    }
    
    
    func addBookmark(from tab: BrowserTab) {
        guard let url = tab.url else { return }
        
        let title = url.absoluteString
      
        
        let bookmark = Bookmark(title: title, url: url)
        bookmarks.append(bookmark)
    }
}
