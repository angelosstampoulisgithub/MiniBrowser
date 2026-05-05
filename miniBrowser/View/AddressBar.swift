//
//  AddressBar.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import SwiftUI

struct AddressBar: View {
    @Binding var urlString: String
    var onGo: (String) -> Void

    var body: some View {
        HStack {
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onSubmit {
                    onGo(urlString)
                }

            Button("Go") {
                onGo(urlString)
            }
        }
        .padding(.horizontal)
    }
}
