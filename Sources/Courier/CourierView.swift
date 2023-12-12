//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

/*
 # ``Courier`` SDK

 An iOS SDK to be able to perform deliveries through Citibox.

 ## Overview

 Citibox is a software platform with the vision of solving the issue receiving parcel and return packages at home.

 Our first iteration is to deploy an open network of smart parcel boxes installed inside residential buildings where customers wants to receive their parcels.

 ![Citibox](citibox.png)

 Thank to the information that Citibox has, the carrier can deliver parcels with an astonishing experience with our custom user flow that has a 85/100 NPS score.
*/

import SwiftUI

/**
 A Courier View to perform deliveries.
 */
public struct CourierView: View {
    private let accessToken: String
    private let tracking: String
    private let recipientPhone: String
    private let dimension: String?
    
    
    /// Initializes the `CourierView` with the needed data.
    ///
    /// - Parameters:
    ///   - accessToken: Mandatory. String. Access token provided via oauth for Citibox server to the Carrier server. Important: The carrier app should never contact the citibox server directly.
    ///   - tracking: Mandatory. String. Scanned barcode or QR code of the package to be delivered.
    ///   - recipientPhone: Mandatory. String. Recipient mobile phone number following standard [E.164](https://en.wikipedia.org/wiki/E.164)
    ///   - dimension: Optional. String. Package height, width and length in millimetres in the following format:{height}x{width}x{length} Ex.: 24x50x75
    public init(accessToken: String, tracking: String, recipientPhone: String, dimension: String? = nil) {
        self.accessToken = accessToken
        self.tracking = tracking
        self.recipientPhone = recipientPhone
        self.dimension = dimension
    }
    
    public var body: some View {
        CourierWebAppView()
    }
}

struct CourierView_Previews: PreviewProvider {
    static var previews: some View {
        CourierView(accessToken: "70K3n", tracking: "7R4CK1N6", recipientPhone: "+34666123456")
    }
}
