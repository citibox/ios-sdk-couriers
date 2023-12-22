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
import AVFoundation

#if os(iOS)
internal struct WebViewScriptMessage {
    var handler: String
    var object: Any
}

internal struct WebView: UIViewRepresentable {
    @Binding var title: String
    var url: URL?
    var html: String?
    var baseURL: URL?
    var scriptMessageHandlers: [String]
    var loadStatusChanged: ((Bool, Error?) -> Void)?
    var loadingProgress: ((Double) -> Void)?
    var receivedMessage: ((WebViewScriptMessage) -> Void)?

    private let webView = WKWebView()
    
    internal init(
        title: Binding<String> = .constant(""),
        url: URL? = nil,
        html: String? = nil,
        baseURL: URL? = nil,
        scriptMessageHandlers: [String] = [],
        loadStatusChanged: ((Bool, Error?) -> Void)? = nil,
        loadingProgress: ((Double) -> Void)? = nil,
        receivedMessage: ((WebViewScriptMessage) -> Void)? = nil
    ) {
        self._title = title
        self.url = url
        self.html = html
        self.baseURL = baseURL
        self.scriptMessageHandlers = scriptMessageHandlers
        self.loadStatusChanged = loadStatusChanged
        self.loadingProgress = loadingProgress
        self.receivedMessage = receivedMessage
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
                
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        
        /*if #available(iOS 15.4, *) {
            webView.configuration.preferences.isElementFullscreenEnabled = false
        } else {
            // Fallback on earlier versions
        }*/
        
        for handler in scriptMessageHandlers {
            webView.configuration.userContentController.add(context.coordinator, name: handler)
        }
        
        /*
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        webView.configuration.websiteDataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        webView.configuration.websiteDataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                        print("[WebCacheCleaner] Record \(record) deleted")
                    }
                }
        */

        if let url = url {
            webView.load(URLRequest(url: url))
        } else if let html = html {
            webView.loadHTMLString(html, baseURL: baseURL)
        }
        
        webView.configuration.allowsInlineMediaPlayback = true
        //webView.configuration.allowsPictureInPictureMediaPlayback = false
        webView.configuration.allowsAirPlayForMediaPlayback = false
        
        if #available(iOS 15.0, *) {
            webView.setCameraCaptureState(.active)
            //webView.setMicrophoneCaptureState(.active)
        } else {
            // Fallback on earlier versions
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate {
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
        
        /*
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard let serverTrust = challenge.protectionSpace.serverTrust  else {
                completionHandler(.useCredential, nil)
                return
            }
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
            
        }
         */
        
        // MARK: - WKScriptMessageHandler
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard parent.scriptMessageHandlers.contains(message.name) else { return }
            let scriptMessage = WebViewScriptMessage(handler: message.name, object: message.body)
            parent.receivedMessage?(scriptMessage)
        }
        
        // MARK: - WKUIDelegate
        
        @available(iOS 15.0, *)
        func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            #warning("Camera usage diabled for now")
            decisionHandler(.deny)
            /*switch type {
            case .camera:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    decisionHandler(granted ? .grant : .deny)
                }
            case .microphone:
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    decisionHandler(granted ? .grant : .deny)
                }
            case .cameraAndMicrophone:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        AVCaptureDevice.requestAccess(for: .audio) { granted in
                            decisionHandler(granted ? .grant : .deny)
                        }
                    } else {
                        decisionHandler(.deny)
                    }
                }
            @unknown default:
                decisionHandler(.deny)
            }*/
        }
        
        
    
    }
}
#endif
