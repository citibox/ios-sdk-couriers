//
//  Checkbox.swift
//  CourierSDKTester
//
//  Created by Marcos Alba on 9/1/24.
//

import SwiftUI

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
