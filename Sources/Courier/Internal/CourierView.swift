//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

internal struct CourierView: View {
    @Binding private var isPresented: Bool
    private let params: DeliveryParams
    private let resultViewModel: DeliveryResultViewModel
    
    internal init(isPresented: Binding<Bool>, params: DeliveryParams, resultViewModel: DeliveryResultViewModel) {
        self._isPresented = isPresented
        self.params = params
        self.resultViewModel = resultViewModel
    }
    
    internal var body: some View {
        CourierWebAppView(
            accessToken: params.accessToken,
            tracking: params.tracking,
            recipientPhone: params.recipientPhone,
            dimensions: params.dimensions,
            bookingId: params.bookingId,
            isSandbox: params.isSandbox,
            debug: params.debug
        ) { result in
            resultViewModel.result = result
            isPresented = false
        }
    }
}
