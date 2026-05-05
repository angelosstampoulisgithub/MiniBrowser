//
//  BookmarksView.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var vm: WebViewModel
    var onSelect: (Bookmark) -> Void

    var body: some View {
        List {
            ForEach(vm.bookmarks) { bookmark in
                Button {
                    onSelect(bookmark)
                } label: {
                    VStack(alignment: .leading) {
                        Text(bookmark.title)
                            .font(.headline)
                        Text(bookmark.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete { indexSet in
                vm.bookmarks.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Bookmarks")
    }
}
