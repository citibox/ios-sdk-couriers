//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

/**
 Parmas needed for delivery
 */
public struct DeliveryParams {
    internal let accessToken: String
    internal let tracking: String
    internal let recipientPhone: String?
    internal let recipientHash: String?
    internal let dimensions: String?
    internal let isSandbox: Bool
    
    /// Initializes the `DeliveryParams` with the needed data.
    ///
    /// - Parameters:
    ///   - accessToken: Mandatory. String. Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.
    ///   - tracking: Mandatory. String. Scanned barcode or QR code of the package to be delivered.
    ///   - recipientPhone: Mandatory. String. Recipient mobile phone number following standard [E.164](https://en.wikipedia.org/wiki/E.164)
    ///   - dimensions: Optional. String. Package height, width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75
    ///   - sandbox: Optional. Bool. Tells if using sandbox environment. False by default.
    public init(accessToken: String, tracking: String, recipientPhone: String, dimensions: String? = nil, sandbox: Bool = false) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.recipientHash = nil
        self.dimensions = dimensions
        self.isSandbox = sandbox
    }
    
    /// Initializes the `DeliveryParams` with the needed data.
    ///
    /// - Parameters:
    ///   - accessToken: Mandatory. String. Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.
    ///   - tracking: Mandatory. String. Scanned barcode or QR code of the package to be delivered.
    ///   - recipientHash: Mandatory. String. Recipient mobile phone number hashed in [SHA-256 algorithm](https://es.wikipedia.org/wiki/SHA-2)
    ///   - dimensions: Optional. String. Package height, width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75
    ///   - sandbox: Optional. Bool. Tells if using sandbox environment. False by default.
    public init(accessToken: String, tracking: String, recipientHash: String, dimensions: String? = nil, sandbox: Bool = false) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = nil
        self.recipientHash = recipientHash
        self.dimensions = dimensions
        self.isSandbox = sandbox
    }
}

/**
 A Courier View to perform deliveries.
 */
public struct CourierView: View {
    private let params: DeliveryParams
    
    
    /// Initializes the `CourierView` with the needed data.
    ///
    /// - params: `DeliveryParams
    
    public init(params: DeliveryParams) {
        self.params = params
    }
    
    public var body: some View {
        CourierWebAppView(
            accessToken: params.accessToken,
            tracking: params.tracking,
            recipientPhone: params.recipientPhone,
            recipientHash: params.recipientHash,
            dimensions: params.dimensions,
            isSandbox: params.isSandbox
        )
    }
}
