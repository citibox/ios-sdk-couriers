//
//  CourierWebAppView.swift
//  Courier
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI

internal struct CourierWebAppView: View {
    internal init() {
        
    }
    
    var body: some View {
        WebView(title: .constant(""), url: URL(string: "https://couriers.citibox.com/courier"))
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        CourierWebAppView()
    }
}
