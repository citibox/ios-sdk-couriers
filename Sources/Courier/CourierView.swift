//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

public struct CourierView: View {
    private let params: DeliveryParams
    
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
