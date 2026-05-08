//
//  BookmarksView.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var vm: WebViewModel
    var onSelect: (BrowserTab) -> Void

    var body: some View {
        List {
            ForEach(vm.bookmarks) { bookmark in
                Button {
                    onSelect(bookmark)
                } label: {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .foregroundColor(.orange)
                        Text(bookmark.url?.absoluteString ?? "Unknown")
                            .lineLimit(1)
                    }
                }
            }
            .onDelete { indexSet in
                vm.bookmarks.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Bookmarks")
        .toolbar {
            EditButton()
        }
    }
}
