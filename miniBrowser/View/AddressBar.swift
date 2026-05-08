//
//  AddressBar.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//
import SwiftUI

struct AddressBar: View {
    @Binding var tab: BrowserTab
    var onGo: (String) -> Void
    
    @State private var text: String = ""
    
    var body: some View {
        HStack {
            TextField("Enter URL", text: $text, onCommit: {
                onGo(text)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Button {
                onGo(text)
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
            }
        }
        .padding(.horizontal)
        .onAppear {
            text = tab.urlString
        }
        .onChange(of: tab.urlString) { newValue in
            text = newValue
        }
    }
    
}
