//
//  ContentView.swift
//  miniBrowser
//
//  Created by Angelos Staboulis on 3/5/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = WebViewModel()
    @State private var showDownloads = false   

    var body: some View {
        VStack(spacing: 0) {

            Text("MiniBrowser")
                .frame(maxWidth: .infinity, maxHeight: 25, alignment: .top)

            TabsBar(vm: vm)

            if let index = vm.tabs.firstIndex(where: { $0.id == vm.selectedTabID }) {

                AddressBar(
                    urlString: Binding(
                        get: { vm.tabs[index].urlString },
                        set: {
                            if !vm.didInitialSync {
                                vm.didInitialSync = true
                                return
                            }

                            vm.tabs[index].urlString = $0

                            guard !$0.isEmpty else { return }

                            if let url = URL(string: $0) {
                                vm.tabs[index].url = url
                            }

                            vm.objectWillChange.send()
                        }
                    ),
                    onGo: { text in
                        var fixed = text
                        if !fixed.hasPrefix("http") {
                            fixed = "https://" + fixed
                        }
                        vm.tabs[index].url = URL(string: fixed)
                        vm.objectWillChange.send()
                    }
                )

                WebView(tab: $vm.tabs[index], userAgent: "miniBrowser/1.0")
                    .id(vm.tabs[index].id)
                    .ignoresSafeArea()

                // MARK: - Safari Style Toolbar
                HStack(spacing: 40) {

                    Button {
                        vm.tabs[index].goBackTrigger.toggle()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                    }
                    .disabled(!vm.tabs[index].canGoBack)

                    Button {
                        vm.tabs[index].goForwardTrigger.toggle()
                    } label: {
                        Image(systemName: "chevron.forward")
                            .font(.title2)
                    }
                    .disabled(!vm.tabs[index].canGoForward)

                    Button {
                        vm.tabs[index].reloadTrigger.toggle()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                    }

                    Button {
                        vm.addBookmark(from: vm.tabs[index])
                    } label: {
                        Image(systemName: "bookmark")
                            .font(.title2)
                    }

                    Button {
                        vm.showBookmarks = true
                    } label: {
                        Image(systemName: "book")
                            .font(.title2)
                    }

                    Button {
                        vm.tabs[index].exportAndShowDownloadsTrigger.toggle()
                        vm.objectWillChange.send()
                    } label: {
                        Image(systemName: "folder")
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $vm.showBookmarks) {
            NavigationView {
                BookmarksView(vm: vm) { bookmark in
                    if let index = vm.tabs.firstIndex(where: { $0.id == vm.selectedTabID }) {
                        vm.tabs[index].url = bookmark.url
                    }
                    vm.showBookmarks = false
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showDownloads)) { _ in
            showDownloads = true
        }
        .sheet(isPresented: $showDownloads) {
            DownloadsView()
        }

    }
}
