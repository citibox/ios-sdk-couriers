//
//  RetrievalView.swift
//  CourierSDKTester
//
//  Created by Marcos Alba on 9/1/24.
//

import SwiftUI
import Courier

struct RetrievalView: View {
    @State var accessToken = ""
    @State var citiboxId = ""
    @State var debug = true
    @State var showCourierView = false
    @ObservedObject var result: RetrievalResultViewModel = .init()
    
    var retrievalParams: RetrievalParams {
        var sandbox = false
        #if DEBUG
        sandbox = true
        #endif
        
        return RetrievalParams(
            accessToken: accessToken,
            citiboxId: Int(citiboxId) ?? -1,
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
                        if res is RetrievalResultSuccess {
                            (res as! RetrievalResultSuccess).view
                        } else if res is RetrievalResultCancel {
                            (res as! RetrievalResultCancel).view
                        } else if res is RetrievalResultError {
                            (res as! RetrievalResultError).view
                        } else if res is RetrievalResultFailure {
                            (res as! RetrievalResultFailure).view
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
                    Text("Citibox ID")
                    TextField("Citibox ID", text: $citiboxId)
                        .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Debug mode", isOn: $debug)
                        .toggleStyle(CheckboxToggleStyle())
                }
                Button("Retrieve 🎣📦") {
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
        .navigationTitle("📦 Retrieval 🎣")
        .courier(isPresented: $showCourierView, params: retrievalParams, result: result)
    }
}

extension RetrievalResult {
    var title: String {
        if self is RetrievalResultSuccess {
            return (self as! RetrievalResultSuccess).title
        } else if self is RetrievalResultCancel {
            return (self as! RetrievalResultCancel).title
        } else if self is RetrievalResultError {
            return (self as! RetrievalResultError).title
        } else if self is RetrievalResultFailure {
            return (self as! RetrievalResultFailure).title
        } else {
            return "No result"
        }
    }
}

extension RetrievalResultSuccess {
    var title: String {
        return "Success"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Box number: \(boxNumber)")
            Text("Citibox ID: \(citiboxId)")
        }
    }
}

extension RetrievalResultCancel {
    var title: String {
        return "Cancel"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cancel code: \(code)")
        }
    }
}

extension RetrievalResultError {
    var title: String {
        return "Error"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Error code: \(code)")
        }
    }
}

extension RetrievalResultFailure {
    var title: String {
        return "Failure"
    }
    
    var view: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Failure code: \(code)")
        }
    }
}


struct RetrievalView_Previews: PreviewProvider {
    static var previews: some View {
        RetrievalView()
    }
}
