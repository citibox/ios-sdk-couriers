//
//  DeliveryParams.swift
//
//
//  Created by Marcos Alba on 12/12/23.
//

import SwiftUI

/**
 Parmas needed for delivery
 */
public struct DeliveryParams {
    internal let accessToken: String
    internal let tracking: String
    internal let recipientPhone: String
    internal let dimensions: String?
    internal let isSandbox: Bool
    internal let debug: Bool

    /// Initializes the `DeliveryParams` with the needed data.
    ///
    /// - Parameters:
    ///   - accessToken: Mandatory. String. Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.
    ///   - tracking: Mandatory. String. Scanned barcode or QR code of the package to be delivered.
    ///   - recipientPhone: Mandatory. String. Recipient mobile phone number following standard [E.164](https://en.wikipedia.org/wiki/E.164)
    ///   - dimensions: Optional. String. Package height, width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75
    ///   - sandbox: Optional. Bool. Tells if using sandbox environment. False by default.
    ///   - debug: Optional. Bool. Shows a differnet view in order to be able to debug the delivery. Is intended to be used when we face some issue that cannot understand o want to verify, like if we are sending the right parameters. False by default.
    public init(accessToken: String, tracking: String, recipientPhone: String, dimensions: String? = nil, sandbox: Bool = false, debug: Bool = false) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.dimensions = dimensions
        self.isSandbox = sandbox
        self.debug = debug
    }
}
