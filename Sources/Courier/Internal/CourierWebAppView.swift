//
//  CourierWebAppView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

internal struct CourierDeliveryWebAppView: View {
    private let accessToken: String
    private let tracking: String
    private let recipientPhone: String?
    private let dimensions: String?
    private let bookingId: String?
    private let isSandbox: Bool
    private let debug: Bool
    private let url: String
    private let resultHandler: ((any DeliveryResult)?) -> Void
    
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
                return jsonData.decode() as DeliveryResultSuccess?
            case .cancel:
                return jsonData.decode() as DeliveryResultCancel?
            case .error:
                return jsonData.decode() as DeliveryResultError?
            case .fail:
                return jsonData.decode() as DeliveryResultFailure?
            }
        }
        
    }
    
    internal init(accessToken: String, tracking: String, recipientPhone: String, dimensions: String?, bookingId: String? = nil, isSandbox: Bool, debug: Bool, resultHandler: @escaping ((any DeliveryResult)?) -> Void) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.dimensions = dimensions
        self.bookingId = bookingId
        self.isSandbox = isSandbox
        self.debug = debug
        self.resultHandler = resultHandler
        
        let env: CourierWebAppEnvironment = isSandbox ? .sandbox : .prod

        var params: [Pairs] = [Pairs.accessToken(accessToken), Pairs.tracking(tracking), Pairs.phone(recipientPhone)]

        if let dimensions = dimensions {
            params += [Pairs.dimensions(dimensions)]
        }
        if let bookingId = bookingId {
            params += [Pairs.bookingId(bookingId)]
        }

        url = CourierWebAppURL(
            environment: isSandbox ? .sandbox : .prod,
            path: .delivery,
            endpoint: debug ? .test : .location,
            params: params
        ).url
    }
    
    var body: some View {
    #if os(iOS)
        WebView(
            url: URL(string: url),
            scriptMessageHandlers: ScriptMessageHandlers.allCases.map({ $0.rawValue }),
            receivedMessage: { message in
                guard let messageHandler = ScriptMessageHandlers(rawValue: message.handler) else { return }
                resultHandler(messageHandler.deliveryResult(from: message.object))
            }
        )
        .edgesIgnoringSafeArea(.bottom)
        .transition(.opacity)
    #else
        EmptyView()
    #endif
    }
}

internal struct CourierRetrievalWebAppView: View {
    private let accessToken: String
    private let citiboxId: Int
    private let isSandbox: Bool
    private let debug: Bool
    private let url: String
    private let resultHandler: ((any RetrievalResult)?) -> Void
    
    private enum ScriptMessageHandlers: String, CaseIterable {
        case success
        case cancel
        case error
        case fail
        
        func retrievalResult(from object: Any) -> (any RetrievalResult)? {
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
                return jsonData.decode() as RetrievalResultSuccess?
            case .cancel:
                return jsonData.decode() as RetrievalResultCancel?
            case .error:
                return jsonData.decode() as RetrievalResultError?
            case .fail:
                return jsonData.decode() as RetrievalResultFailure?
            }
        }
        
    }
    
    internal init(accessToken: String, citiboxId: Int, isSandbox: Bool, debug: Bool, resultHandler: @escaping ((any RetrievalResult)?) -> Void) {
        self.accessToken = accessToken
        self.citiboxId = citiboxId
        self.isSandbox = isSandbox
        self.debug = debug
        self.resultHandler = resultHandler
        
        let params: [Pairs] = [Pairs.accessToken(accessToken), Pairs.citiboxId(citiboxId)]
        url = CourierWebAppURL(
            environment: isSandbox ? .sandbox : .prod,
            path: .retrieval,
            endpoint: debug ? .test : .location,
            params: params
        ).url
    }
    
    var body: some View {
    #if os(iOS)
        WebView(
            url: URL(string: url),
            scriptMessageHandlers: ScriptMessageHandlers.allCases.map({ $0.rawValue }),
            receivedMessage: { message in
                guard let messageHandler = ScriptMessageHandlers(rawValue: message.handler) else { return }
                print("Received Message from handler \(messageHandler.rawValue)\n\(message.object)")
                resultHandler(messageHandler.retrievalResult(from: message.object))
            }
        )
        .edgesIgnoringSafeArea(.bottom)
        .transition(.opacity)
    #else
        EmptyView()
    #endif
    }
}

private struct CourierWebAppURL {
    let environment: CourierWebAppEnvironment
    let path: CourierWebAppPath
    let endpoint: CourierWebAppEndpoint
    let params: [Pairs]
    
    var url: String {
        let params = params.map({ $0.pair }).joined(separator: "&")
        return "\(environment.host)/\(path.rawValue)/\(endpoint.rawValue)?\(params)"
    }
}

private enum CourierWebAppEnvironment {
    case prod
    case sandbox
    
    var host: String {
        switch self {
        case .prod:
            return "https://shipping.citibox.com"
        case .sandbox:
            return "https://shipping.citibox-sandbox.com"
        }
    }
}

private enum CourierWebAppPath: String {
    case delivery
    case retrieval
}

private enum CourierWebAppEndpoint: String {
    case test
    case location
}

private enum Params: String {
    case access_token
    case tracking
    case recipient_phone
    case dimensions
    case booking_id
    case citibox_id
}

private enum Pairs {
    case accessToken(String)
    case tracking(String)
    case phone(String)
    case dimensions(String)
    case bookingId(String)
    case citiboxId(Int)
    
    var pair: String {
        switch self {
        case .accessToken(let value):
            return param(key: Params.access_token.rawValue, value: value)
        case .tracking(let value):
            return param(key: Params.tracking.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "InvalidTracking")
        case .phone(let value):
            return param(key: Params.recipient_phone.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "InvalidPhone")
        case .dimensions(let value):
            return param(key: Params.dimensions.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .decimalDigits) ?? "InvalidDimensions")
        case .bookingId(let value):
            return param(key: Params.booking_id.rawValue, value: value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "InvalidBookingId")
        case .citiboxId(let value):
            return param(key: Params.citibox_id.rawValue, value: String(value).addingPercentEncoding(withAllowedCharacters: .decimalDigits) ?? "InvalidCitiboxId")
        }
    }
    
    func param(key: String, value: String) -> String {
        "\(key)=\(value)"
    }
}

extension Data {
    func decode<T>() -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch(let error) {
            print("Error decoding DeliveryResultSuccess: \(error)")
            return nil
        }
    }
}
