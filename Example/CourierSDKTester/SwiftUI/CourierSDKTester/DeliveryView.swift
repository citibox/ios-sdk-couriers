//
//  ContentView.swift
//  CourierSDKTester
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI
import Courier

struct DeliveryView: View {
    @State var accessToken = ""
    @State var tracking = ""
    @State var phone = ""
    @State var height: String = ""
    @State var width: String = ""
    @State var length: String = ""
    @State var bookingId: String = ""
    @State var debug = true
    @State var showCourierView = false
    @ObservedObject var result: DeliveryResultViewModel = .init()

    var deliveryParams: DeliveryParams {
        var sandbox = false
        #if DEBUG
        sandbox = true
        #endif
        
        let dims: String? = (height.isEmpty || width.isEmpty || length.isEmpty) ? nil : "\(height)x\(width)x\(length)"
        
        return DeliveryParams(
            accessToken: accessToken,
            tracking: tracking,
            recipientPhone: phone,
            dimensions: dims,
            bookingId: bookingId.isEmpty ? nil : bookingId,
            sandbox: sandbox,
            debug: debug
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let res = result.result {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Result")
                                .font(.title)
                            Text(res.title)
                                .fontWeight(.bold)
                        }
                        if res is DeliveryResultSuccess {
                            (res as! DeliveryResultSuccess).view
                        } else if res is DeliveryResultCancel {
                            (res as! DeliveryResultCancel).view
                        } else if res is DeliveryResultError {
                            (res as! DeliveryResultError).view
                        } else if res is DeliveryResultFailure {
                            (res as! DeliveryResultFailure).view
                        } else {
                            EmptyView()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.4)),
                        alignment: .leading
                    )
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Access token")
                    TextField("Access token", text: $accessToken)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tracking")
                    TextField("Tracking", text: $tracking)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone")
                    TextField("Phone", text: $phone)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dimensions")
                    HStack {
                        TextField("height", text: $height)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        Text("x")
                        TextField("width", text: $width)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        Text("x")
                        TextField("length", text: $length)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Booking ID")
                    TextField("Booking identificator", text: $bookingId)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Debug mode", isOn: $debug)
                        .toggleStyle(CheckboxToggleStyle())
                }
                Button("Deliver 🚀📦") {
                    showCourierView = true
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .padding(.horizontal,10)
                .background(Color(red: 0.47, green: 0.26, blue: 0.93))
                .foregroundColor(.white)
                .clipShape(Capsule())
                Spacer()
            }
            .padding(16)
        }
        .interactiveDismissDisabled(false)
        .navigationTitle("📦 Delivery 🚀")
        .courier(isPresented: $showCourierView, params: deliveryParams, result: result)
    }
}

extension DeliveryResult {
    var title: String {
        if self is DeliveryResultSuccess {
            return (self as! DeliveryResultSuccess).title
        } else if self is DeliveryResultCancel {
            return (self as! DeliveryResultCancel).title
        } else if self is DeliveryResultError {
            return (self as! DeliveryResultError).title
        } else if self is DeliveryResultFailure {
            return (self as! DeliveryResultFailure).title
        } else {
            return "No result"
        }
    }
}

extension DeliveryResultSuccess {
    var title: String {
        return "Success"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Box number: \(boxNumber)")
            Text("Citibox ID: \(citiboxId)")
                .textSelection(.enabled)
            Text("Delivery ID: \(deliveryId)")
        }
    }
}

extension DeliveryResultCancel {
    var title: String {
        return "Cancel"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cancel code: \(code)")
        }
    }
}

extension DeliveryResultError {
    var title: String {
        return "Error"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Error code: \(code)")
        }
    }
}

extension DeliveryResultFailure {
    var title: String {
        return "Failure"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Failure code: \(code)")
        }
    }
}


struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
