//
//  ContentView.swift
//  CourierSDKTester
//
//  Created by Marcos Alba on 6/7/23.
//

import SwiftUI
import Courier

struct ContentView: View {
    @State var accessToken = "hZ8FtFdwiBFXztnjDeqFfZbf3XRiTp"
    @State var tracking = ""
    @State var phone = ""
    @State var hashed = false
    @State var height: String = ""
    @State var width: String = ""
    @State var length: String = ""
    @State var showCourierView = false
    @ObservedObject var result: DeliveryResultViewModel = .init()

    var deliveryParams: DeliveryParams {
        var sandbox = false
        #if DEBUG
        sandbox = true
        #endif
        
        let dims: String? = (height.isEmpty || width.isEmpty || length.isEmpty) ? nil : "\(height)x\(width)x\(length)"
        
        if hashed {
           return DeliveryParams(
            accessToken: accessToken,
            tracking: tracking,
            recipientHash: phone.sha256(),
            dimensions: dims,
            sandbox: sandbox
           )
        } else {
            return DeliveryParams(
                accessToken: accessToken,
                tracking: tracking,
                recipientPhone: phone,
                dimensions: dims,
                sandbox: sandbox
            )
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if let res = result.result {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.4))
                        .overlay(alignment: .leading) {
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
                            .padding(16)
                        }
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
                    Toggle("Hashed", isOn: $hashed)
                        .toggleStyle(CheckboxToggleStyle())
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dimensions")
                    HStack {
                        TextField("height", text: $height)
                            .textFieldStyle(.roundedBorder)
                        Text("x")
                        TextField("width", text: $width)
                            .textFieldStyle(.roundedBorder)
                        Text("x")
                        TextField("length", text: $length)
                            .textFieldStyle(.roundedBorder)
                    }
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
            .padding()
            .navigationTitle("Citibox Courier Demo")
            .courier(isPresented: $showCourierView, params: deliveryParams, result: result)
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
   func makeBody(configuration: Configuration) -> some View {
       HStack {
           RoundedRectangle(cornerRadius: 5.0)
               .stroke(lineWidth: 2)
               .frame(width: 25, height: 25)
               .cornerRadius(5.0)
               .overlay {
                   Image(systemName: configuration.isOn ?"checkmark" : "")
               }
               .onTapGesture {
                   withAnimation(.spring()) {
                       configuration.isOn.toggle()
                   }
               }
           
           configuration.label
           
       }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
