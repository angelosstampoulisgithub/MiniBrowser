//
//  TabsBar.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import SwiftUI

struct TabsBar: View {
    @ObservedObject var vm: WebViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.tabs) { tab in
                    Button {
                        vm.selectedTabID = tab.id
                    } label: {
                        Text(tab.title)
                            .padding(8)
                            .background(vm.selectedTabID == tab.id ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(6)
                    }
                }

                Button("+") {
                    vm.addTab()
                }
                .padding(.leading, 8)
            }
            .padding(.horizontal)
        }
    }
}
