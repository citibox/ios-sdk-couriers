//
//  Courier.swift
//
//
//  Created by Marcos Alba on 13/12/23.
//

import SwiftUI

extension View {
    /**
     Courier View Modifier
     
     Presents Courier View in full screen.
    
     - parameters:
       - isPresented: `Binding<Bool>`. Controls wheter view is presented or not. When a result is received it is automatically dismissed.
       - params: `DeliveryParams`. Required parameters.
       - result: `DeliveryResultViewModel`. Result received. You can observe this in order to get updates on result.
     
     - seealso:
       - `DeliveryParams`
       - `DeliveryResultViewModel`
     */
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
}
