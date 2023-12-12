//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

/**
 A Courier View to perform deliveries.
 */
public struct CourierView: View {
    private let accessToken: String
    private let tracking: String
    private let recipientPhone: String?
    private let recipientHash: String?
    private let dimensions: String?
    private let isSandbox: Bool
    
    
    /// Initializes the `CourierView` with the needed data.
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
    
    /// Initializes the `CourierView` with the needed data.
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
    
    public var body: some View {
        CourierWebAppView(
            accessToken: accessToken,
            tracking: tracking,
            recipientPhone: recipientPhone,
            recipientHash: recipientHash,
            dimensions: dimensions,
            isSandbox: isSandbox
        )
    }
}

struct CourierView_Previews: PreviewProvider {
    static var previews: some View {
        CourierView(accessToken: "70K3n", tracking: "7R4CK1N6", recipientPhone: "+34666123456")
    }
}
