//
//  ContentView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import SwiftUI

struct InputAmountView: View {
    
    @StateObject var payment = Payment()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ingresa un monto a pagar")
                    .font(.headline)
                    .padding()
                
                TextField("", value: $payment.amount, format: .currency(code: "CLP"), prompt: Text(""))
                    .font(.system(size: 60, weight: .light, design: .rounded))
                    .textFieldStyle(.roundedBorder)
                    .shadow(radius: 5)
                    .padding()
                    .keyboardType(.numberPad)
    
                HStack {
                    Spacer()
                    
                    NavigationLink("Continuar", destination: SelectPaymentMethodView(), isActive: $payment.paymentInProcess)
                        .isDetailLink(false)
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.amount == 0)
                    .padding()
                }
                
                Spacer()
                
            }
            .navigationTitle("MeLiPay")
            .background(
                LinearGradient(gradient: Gradient(colors: [.teal, .white , .white, .white]), startPoint: .top, endPoint: .bottom)
                )
            
        }
        .sheet(isPresented: $payment.paymentComplete,onDismiss: { payment.resetPayment() }, content: {
            VStack(alignment: .leading, spacing: 30) {
                Text("Pago Realizado")
                    .font(.largeTitle)
                PaymentSummaryView(payment: payment, summaryStyle: .regular)
                Button("Comenzar nuevo pago") {
                payment.resetPayment()
            }
            .buttonStyle(.borderedProminent)
            }
        })
        .environmentObject(payment)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InputAmountView()
    }
}
