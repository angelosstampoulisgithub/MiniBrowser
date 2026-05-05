//
//  PDFManager.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 5/5/26.
//

import Foundation

final class PDFManager {
    static let shared = PDFManager()
    private init() {}

    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func savePDF(_ data: Data) throws -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())

        let fileURL = documentsURL.appendingPathComponent("page_\(timestamp).pdf")
        try data.write(to: fileURL)
        return fileURL
    }

    func listPDFs() -> [URL] {
        let files = (try? FileManager.default.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: nil
        )) ?? []

        return files.filter { $0.pathExtension.lowercased() == "pdf" }
            .sorted { $0.lastPathComponent > $1.lastPathComponent }
    }

    func delete(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
