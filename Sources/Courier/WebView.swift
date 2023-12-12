//
//  WebView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

import Foundation
import SwiftUI
import WebKit

#if os(iOS)
internal struct WebView: UIViewRepresentable {
    @Binding var title: String
    var url: URL?
    var html: String?
    var baseURL: URL?
    var loadStatusChanged: ((Bool, Error?) -> Void)?
    var loadingProgress: ((Double) -> Void)?
    var isFinished: (() -> Void)?

    private let webView = WKWebView()
    
    internal init(
        title: Binding<String>,
        url: URL? = nil,
        html: String? = nil,
        baseURL: URL? = nil,
        loadStatusChanged: ((Bool, Error?) -> Void)? = nil,
        loadingProgress: ((Double) -> Void)? = nil,
        isFinished: (() -> Void)? = nil
    ) {
        self._title = title
        self.url = url
        self.html = html
        self.baseURL = baseURL
        self.loadStatusChanged = loadStatusChanged
        self.loadingProgress = loadingProgress
        self.isFinished = isFinished
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        // var webView = WKWebView()

        if let url = url {
            webView.load(URLRequest(url: url))
        } else if let html = html {
            webView.loadHTMLString(html, baseURL: baseURL)
        }

        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebView
        private var progressObserver: NSKeyValueObservation?

        init(_ parent: WebView) {
            self.parent = parent
            super.init()

            progressObserver = parent.webView.observe(\.estimatedProgress, changeHandler: { [weak self] webView, _ in
                guard let self = self else { return }
                self.parent.loadingProgress?(webView.estimatedProgress)
            })
        }

        deinit {
            progressObserver = nil
        }

        // MARK: - WKNavigationDelegate

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            guard let comps = navigationAction.request.url?.pathComponents else {
                decisionHandler(.allow)
                return
            }
            let shouldFinish = comps.contains(where: { $0 == "typeform" }) && comps.contains(where: { $0 == "close" })
            guard shouldFinish else {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            parent.isFinished?()
        }

    }
}
#endif
