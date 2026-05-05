//
//  Bookmark.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import Foundation
import SwiftUI

struct Bookmark: Identifiable, Codable {
    let id = UUID()
    let title: String
    let url: URL
}
