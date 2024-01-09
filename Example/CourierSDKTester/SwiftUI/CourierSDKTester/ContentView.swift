//
//  ContentView.swift
//  CourierSDKTester
//
//  Created by Marcos Alba on 9/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create a new transaction to deliver a parcel.")
                NavigationLink("📦 Delivery 🚀") {
                    DeliveryView()
                }
                Divider()
                Text("Create a new transaction to retreive a parcel.")
                NavigationLink("📦 Retrieval 🎣") {
                    RetrievalView()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Citibox Courier Demo")
        }
    }
}
