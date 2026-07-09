//
//  PaymentWebView.swift
//  Drape
//

import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    let url: URL
    let onRedirect: (URL) -> Bool

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(onRedirect: onRedirect)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let onRedirect: (URL) -> Bool

        init(onRedirect: @escaping (URL) -> Bool) {
            self.onRedirect = onRedirect
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            if let url = navigationAction.request.url {
                if onRedirect(url) {
                    decisionHandler(.cancel)
                    return
                }
            }

            decisionHandler(.allow)
        }
    }
}
