//
//  SelectBankIssuerView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 16-06-22.
//

import SwiftUI

struct SelectBankIssuerView: View {
    
    @State private var bankIssuers: [BankIssuer] = []
    @ObservedObject var payment: Payment
    @State private var selectedBankIssuer: BankIssuer? = nil
    
    let apiServices = ApiServices()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Selecciona un método de pago")
                .font(.headline)
                .padding()
            
            VStack {
                
                Picker("Medio de Pago", selection: $selectedBankIssuer) {
                    ForEach(bankIssuers, id: \.self.id) {
                        bankIssuer in
                        
                        Text(bankIssuer.name)
                        
                    }
                }
                .pickerStyle(.wheel)
                
                HStack {
                    Spacer()
                    NavigationLink("Continuar") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                Spacer()
            }
            
            
            
        }
        .task {
            if let paymentMethod = payment.paymentMethod {
                await bankIssuers = apiServices.requestBankIssuers(id: paymentMethod.id)
            }
        }
    }
    
    
}

struct SelectBankIssuerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankIssuerView(payment: Payment())
    }
}
