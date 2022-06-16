//
//  ContentView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import SwiftUI

struct ContentView: View {
    
//    @State private var amount: Int = 0
    
    @StateObject var payment = Payment()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ingresa un monto a pagar")
                    .font(.headline)
                    .padding()
                
                TextField("", value: $payment.amount, format: .currency(code: "CLP"), prompt: Text(""))
//                    .frame(maxWidth: 400, minHeight: 50, idealHeight: 100, alignment: .center)
                    .font(.system(size: 60, weight: .light, design: .rounded))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .keyboardType(.numberPad)
    
                HStack {
                    Spacer()
                    
                    NavigationLink("Continuar", destination: SelectPaymentMethodView(payment: payment))
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.amount == 0)
                    .padding()
                }
                
                Spacer()
                
            }
            .navigationTitle("MeLiPay")
        }
    }
}

extension Formatter {
    static let lucNumberFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CLP"
        formatter.currencyGroupingSeparator = "."
        formatter.minusSign = "👺 "  // Just for fun!
        formatter.zeroSymbol = ""  // Show empty string instead of zero
        return formatter
    }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
