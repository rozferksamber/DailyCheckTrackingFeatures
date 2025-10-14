//
//  CircleView.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import SwiftUI
import WebKit
import UIKit

struct CircleView: View {
    @StateObject private var viewModel = CircleViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            CircleContentView(
                link: viewModel.serverLink,
                isLoading: $viewModel.isLoading
            )
            .ignoresSafeArea()
            .opacity(viewModel.isLoading ? 0 : 1)
            
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }
        }
        .statusBar(hidden: true)
        .persistentSystemOverlays(.hidden)
        .onAppear {
            viewModel.loadLink()
            AppDelegate.setOrientationLock(.all)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
                    if let viewController = windowScene.windows.first?.rootViewController {
                        viewController.setNeedsUpdateOfSupportedInterfaceOrientations()
                    }
                }
            }
        }
        .onDisappear {
            AppDelegate.setOrientationLock(.portrait)
        }
    }
}

struct CircleContentView: UIViewRepresentable {
    let link: String
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let circleViews = WKWebView(frame: .zero, configuration: configuration)
        circleViews.navigationDelegate = context.coordinator
        circleViews.allowsBackForwardNavigationGestures = true
        circleViews.scrollView.contentInsetAdjustmentBehavior = .never
        circleViews.isOpaque = false
        circleViews.backgroundColor = .black
        circleViews.scrollView.backgroundColor = .black
        
        return circleViews
    }
    
    func updateUIView(_ circleViews: WKWebView, context: Context) {
        if !link.isEmpty, circleViews.url == nil {
            if let requestPath = URL(string: link) {
                let request = URLRequest(url: requestPath)
                circleViews.load(request)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        private var isFirstLoad = true
        
        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }
        
        func webView(_ circleViews: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if isFirstLoad {
                isLoading = true
            }
        }
        
        func webView(_ circleViews: WKWebView, didFinish navigation: WKNavigation!) {
            if isFirstLoad {
                isLoading = false
                isFirstLoad = false
            }
        }
        
        func webView(_ circleViews: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            if isFirstLoad {
                isLoading = false
                isFirstLoad = false
            }
        }
        
        func webView(_ circleViews: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            if isFirstLoad {
                isLoading = false
                isFirstLoad = false
            }
        }
    }
}

