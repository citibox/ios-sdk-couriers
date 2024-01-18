//
//  Courier.swift
//
//
//  Created by Marcos Alba on 13/12/23.
//

import SwiftUI

extension View {
    /**
     Courier View Modifier for a Delivery
     
     Presents Courier View in full screen.
    
     - parameters:
       - isPresented: `Binding<Bool>`. Controls wheter view is presented or not. When a result is received it is automatically dismissed.
       - params: `DeliveryParams`. Required parameters.
       - result: `DeliveryResultViewModel`. Result received. You can observe this in order to get updates on result.
     
     - seealso:
       - `DeliveryParams`
       - `DeliveryResultViewModel`
     */
    @available(iOS 14.0, *)
    public func courier(isPresented: Binding<Bool>, params: DeliveryParams, result: DeliveryResultViewModel) -> some View {
        modifier(
            FullScreenModifier(
                isPresented: isPresented,
                builder: {
                    CourierView(
                        isPresented: isPresented,
                        params: params,
                        resultViewModel: result
                    )
                }
            )
        )
    }
    
    /**
     Courier View Modifier for a Retrieval
     
     Presents Courier View in full screen.
    
     - parameters:
       - isPresented: `Binding<Bool>`. Controls wheter view is presented or not. When a result is received it is automatically dismissed.
       - params: `RetrievalParams`. Required parameters.
       - result: `RetrievalResultViewModel`. Result received. You can observe this in order to get updates on result.
     
     - seealso:
       - `RetrievalParams`
       - `RetrievalResultViewModel`
     */
    @available(iOS 14.0, *)
    public func courier(isPresented: Binding<Bool>, params: RetrievalParams, result: RetrievalResultViewModel) -> some View {
        modifier(
            FullScreenModifier(
                isPresented: isPresented,
                builder: {
                    CourierView(
                        isPresented: isPresented,
                        params: params,
                        resultViewModel: result
                    )
                }
            )
        )
    }
}

// MARK: - UIKit Support

public struct DeliveryView: View {
    let params: DeliveryParams
    let result: ((any DeliveryResult)?) -> Void

    public init(params: DeliveryParams, result: @escaping ((any DeliveryResult)?) -> Void) {
        self.params = params
        self.result = result
    }

    public var body: some View {
        CourierView(
            isPresented: .constant(false),
            params: params,
            result: result
        )
    }
}

public struct RetrievalView: View {
    let params: RetrievalParams
    let result: ((any RetrievalResult)?) -> Void
    
    public init(params: RetrievalParams, result: @escaping ((any RetrievalResult)?) -> Void) {
        self.params = params
        self.result = result
    }
    
    public var body: some View {
        CourierView(
            isPresented: .constant(false),
            params: params,
            result: result
        )
    }
}
