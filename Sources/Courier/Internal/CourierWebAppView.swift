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
    private let resultHandler: ((any DeliveryResult)?) -> Void
    
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
                return param(key: Params.tracking.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "InvalidTracking")
            case .phone(let value):
                return param(key: Params.recipient_phone.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "InvalidPhone")
            case .hash(let value):
                return param(key: Params.recipient_hash.rawValue, value: value)
            case .dimensions(let value):
                return param(key: Params.dimensions.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .decimalDigits) ?? "InvalidDimensions")
            }
        }
        
        func param(key: String, value: String) -> String {
            "\(key)=\(value)"
        }
    }
    
    private enum ScriptMessageHandlers: String, CaseIterable {
        case success
        case cancel
        case error
        case fail
        
        func deliveryResult(from object: Any) -> (any DeliveryResult)? {
            guard let dict = object as? [String: Any] else {
                print("Object is not a dictionary [String: Any]")
                return nil
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict) else {
                print("Canot get json data")
                return nil
            }

            switch self {
            case .success:
                return decodeResult(from: jsonData) as DeliveryResultSuccess?
            case .cancel:
                return decodeResult(from: jsonData) as DeliveryResultCancel?
            case .error:
                return decodeResult(from: jsonData) as DeliveryResultError?
            case .fail:
                return decodeResult(from: jsonData) as DeliveryResultFailure?
            }
        }
        
        func decodeResult<T>(from jsonData: Data) -> T? where T: Decodable {
            do {
                return try JSONDecoder().decode(T.self, from: jsonData)
            } catch(let error) {
                print("Error decoding DeliveryResultSuccess: \(error)")
                return nil
            }
        }
    }
    
    internal init(accessToken: String, tracking: String, recipientPhone: String?, recipientHash: String?, dimensions: String?, isSandbox: Bool, resultHandler: @escaping ((any DeliveryResult)?) -> Void) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.recipientHash = recipientHash
        self.dimensions = dimensions
        self.isSandbox = isSandbox
        self.resultHandler = resultHandler
        
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

#warning("TESTING")
        //url = "\(host)/deeplink-delivery/?\(params)"
        url = "http://localhost:8080/deeplink-delivery/?\(params)"
    }
    
    var body: some View {
        WebView(
            url: URL(string: url),
            scriptMessageHandlers: ScriptMessageHandlers.allCases.map({ $0.rawValue }),
            receivedMessage: { message in
                guard let messageHandler = ScriptMessageHandlers(rawValue: message.handler) else { return }
                print("Received Message from handler \(messageHandler.rawValue)\n\(message.object)")
                resultHandler(messageHandler.deliveryResult(from: message.object))
            }
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

private extension CourierWebAppView {
    static let prodURL = "https://app.courier.citibox.com"
    static let sandboxURL = "https://app.courier.citibox-sandbox.com"

    var host: String {
        isSandbox ? CourierWebAppView.sandboxURL : CourierWebAppView.prodURL
    }
}
