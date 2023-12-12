//
//  CourierWebAppView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

internal struct CourierWebAppView: View {
    private let accessToken: String
    private let tracking: String
    private let recipientPhone: String?
    private let recipientHash: String?
    private let dimensions: String?
    private let isSandbox: Bool
    private let url: String
    
    private enum Params: String {
        case access_token
        case tracking
        case recipient_phone
        case recipient_hash
        case dimensions
    }
    
    private enum Pairs {
        case accessToken(String)
        case tracking(String)
        case phone(String)
        case hash(String)
        case dimensions(String)
        
        var pair: String {
            switch self {
            case .accessToken(let value):
                return param(key: Params.access_token.rawValue, value: value)
            case .tracking(let value):
                return param(key: Params.tracking.rawValue, value: value)
            case .phone(let value):
                return param(key: Params.recipient_phone.rawValue, value: value)
            case .hash(let value):
                return param(key: Params.recipient_hash.rawValue, value: value)
            case .dimensions(let value):
                return param(key: Params.dimensions.rawValue, value: value)
            }
        }
        
        func param(key: String, value: String) -> String {
            "\(key)=\(value)"
        }
    }
    
    internal init(accessToken: String, tracking: String, recipientPhone: String?, recipientHash: String?, dimensions: String?, isSandbox: Bool) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.recipientHash = recipientHash
        self.dimensions = dimensions
        self.isSandbox = isSandbox
        
        let host: String = isSandbox ? CourierWebAppView.sandboxURL : CourierWebAppView.prodURL
        var params: String = Pairs.accessToken(accessToken).pair + "&" + Pairs.tracking(tracking).pair
        if let phone = recipientPhone {
            params += "&" + Pairs.phone(phone).pair
        }
        if let hash = recipientHash {
            params += "&" + Pairs.hash(hash).pair
        }
        if let dimensions = dimensions {
            params += "&" + Pairs.dimensions(dimensions).pair
        }

        url = "\(host)/?\(params)"
    }
    
    var body: some View {
        WebView(title: .constant(""), url: URL(string: url))
    }
}

private extension CourierWebAppView {
    static let prodURL = "https://app.courier.citibox.com"
    static let sandboxURL = "https://app.courier.citibox-sandbox.com"
    
    var host: String {
        isSandbox ? CourierWebAppView.sandboxURL : CourierWebAppView.prodURL
    }
}
