//
//  MiniBrowserViewModel.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import WebKit
// MARK: - ViewModel

import SwiftUI

class WebViewModel: ObservableObject {
    @Published var tabs: [BrowserTab] = [
        BrowserTab(url: URL(string: "https://apple.com"))
    ]

    @Published var selectedTabID: UUID?
    @Published var showBookmarks = false
    @Published var bookmarks: [BrowserTab] = []

    init() {
        selectedTabID = tabs.first?.id
    }

    func addBookmark(from tab: BrowserTab) {
        if !bookmarks.contains(where: { $0.url == tab.url }) {
            bookmarks.append(tab)
        }
    }
}
