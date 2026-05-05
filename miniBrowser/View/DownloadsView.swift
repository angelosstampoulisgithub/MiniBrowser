//
//  DownloadsView.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 5/5/26.
//

import SwiftUI

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct DownloadsView: View {
    @State private var pdfs: [URL] = PDFManager.shared.listPDFs()
    @State private var shareURL: IdentifiableURL?
    @State private var previewURL: IdentifiableURL?

    var body: some View {
        NavigationView {
            List {
                ForEach(pdfs, id: \.self) { url in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(url.lastPathComponent)
                                .font(.headline)
                            Text(formattedDate(from: url))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button {
                            previewURL = IdentifiableURL(url: url)
                        } label: {
                            Image(systemName: "doc.text.magnifyingglass")
                        }
                        .buttonStyle(.borderless)

                        Button {
                            shareURL = IdentifiableURL(url: url)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .buttonStyle(.borderless)

                        Button(role: .destructive) {
                            PDFManager.shared.delete(url)
                            pdfs = PDFManager.shared.listPDFs()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
            .navigationTitle("Downloads")
            .sheet(item: $shareURL) { item in
                ShareSheet(activityItems: [item.url])
            }
            .fullScreenCover(item: $previewURL) { item in
                QuickLookPreview(url: item.url)
            }
        }
    }

    private func formattedDate(from url: URL) -> String {
        let name = url.lastPathComponent
            .replacingOccurrences(of: "page_", with: "")
            .replacingOccurrences(of: ".pdf", with: "")
        return name.replacingOccurrences(of: "_", with: " ")
    }
}
