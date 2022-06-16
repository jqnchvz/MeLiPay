//
//  SelectPaymentMethodView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import SwiftUI

enum PaymentType: String, Equatable, CaseIterable {
    case credit = "credit_card"
    case debit = "debit_card"
    case ticket = "ticket"
    
}

struct SelectPaymentMethodView: View {
    
    @State private var paymentMethods: [PaymentMethod] = []
    @ObservedObject var payment: Payment
    @State private var selectedPaymentType: PaymentType = .credit
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    
    let apiServices = ApiServices()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Selecciona un método de pago")
                .font(.headline)
                .padding()
            
            VStack {
                
                Picker("Tipo de pago", selection: $selectedPaymentType) {
                    ForEach(PaymentType.allCases, id: \.self) { paymentType in
                        
                        Text(paymentType.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                let PaymentOptions = paymentMethods.filter {
                    $0.payment_type_id == selectedPaymentType.rawValue
                }
                
                Picker("Medio de Pago", selection: $payment.paymentMethod) {
                    ForEach(PaymentOptions, id: \.self) {
                        paymentOption in
                        
                        Text(paymentOption.name)
                        
                    }
                }
                .pickerStyle(.wheel)
                
                HStack {
                    Spacer()
                    NavigationLink("Continuar") {
                        SelectBankIssuerView(payment: payment)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                Spacer()
            }
            
            
            
        }
        .task {
            if paymentMethods.isEmpty{
                await paymentMethods = apiServices.requestPaymentMethods()
            }
        }
    }
    
    
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentMethodView(payment: Payment())
    }
}
