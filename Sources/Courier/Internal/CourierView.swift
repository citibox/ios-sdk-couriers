//
//  CourierView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

internal struct CourierView: View {
    @Binding private var isPresented: Bool
    private let deliveryParams: DeliveryParams?
    private let deliveryResultViewModel: DeliveryResultViewModel?
    private let retrievalParams: RetrievalParams?
    private let retrievalResultViewModel: RetrievalResultViewModel?
    
    internal init(isPresented: Binding<Bool>, params: DeliveryParams, resultViewModel: DeliveryResultViewModel) {
        self._isPresented = isPresented
        self.deliveryParams = params
        self.deliveryResultViewModel = resultViewModel
        self.retrievalParams = nil
        self.retrievalResultViewModel = nil
    }
    
    internal init(isPresented: Binding<Bool>, params: RetrievalParams, resultViewModel: RetrievalResultViewModel) {
        self._isPresented = isPresented
        self.deliveryParams = nil
        self.deliveryResultViewModel = nil
        self.retrievalParams = params
        self.retrievalResultViewModel = resultViewModel
    }
    
    internal var body: some View {
        if let params = deliveryParams, let resultViewModel = deliveryResultViewModel {
            CourierDeliveryWebAppView(
                accessToken: params.accessToken,
                tracking: params.tracking,
                recipientPhone: params.recipientPhone,
                dimensions: params.dimensions,
                isSandbox: params.isSandbox,
                debug: params.debug
            ) { result in
                resultViewModel.result = result
                isPresented = false
            }
        } else if let params = retrievalParams, let resultViewModel = retrievalResultViewModel {
            CourierRetrievalWebAppView(
                accessToken: params.accessToken,
                citiboxId: params.citiboxId,
                isSandbox: params.isSandbox,
                debug: params.debug
            ) { result in
                resultViewModel.result = result
                isPresented = false
            }
        } else {
            EmptyView()
        }
    }
}
