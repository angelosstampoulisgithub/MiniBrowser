//
//  AddressBar.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//
import SwiftUI

struct AddressBar: View {
    @Binding var tab: BrowserTab
    let onGo: (String) -> Void

    var body: some View {
        VStack(spacing: 4) {

            HStack {
                TextField("Enter URL", text: $tab.urlString)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .disabled(tab.isLoading)
                    .onTapGesture { tab.isTyping = true }
                    .onSubmit {
                        tab.isTyping = false
                        onGo(tab.urlString)
                    }

                if tab.isLoading {
                    ProgressView()
                }
            }

            if tab.isLoading {
                ProgressView()
            }
        }
    }
}
