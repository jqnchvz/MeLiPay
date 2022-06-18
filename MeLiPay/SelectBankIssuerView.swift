//
//  SelectBankIssuerView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 16-06-22.
//

import SwiftUI

struct SelectBankIssuerView: View {
    
    @State private var bankIssuers: [BankIssuer] = []
//    @ObservedObject var payment: Payment
//    @State private var selectedBankIssuer: BankIssuer? = nil
    
    @EnvironmentObject var payment: Payment
    
    let apiServices = ApiServices()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Resumen")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .top){
                Text("Monto:\n$\(payment.amount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                
                Text("Tipo de Pago:\n\(payment.paymentMethod?.name ?? "N/A")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                
                Text("Emisor:\n\(payment.bankIssuer?.name ?? "N/A")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
            Text("Selecciona un emisor")
                .font(.headline)
                .padding()
            
            VStack {
                ScrollView {
                    
                    ForEach(bankIssuers, id: \.self.id) { bankIssuer in
                        
                        HStack {
                            if let thumbnailUrl = URL(string: bankIssuer.secure_thumbnail) {
                                AsyncImage(url: thumbnailUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 50, height: 20)
                                }
                            }
                            Text(bankIssuer.name)
                            Spacer()
                            
                            if payment.bankIssuer == bankIssuer {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                        .frame(height: 50)
                        .background(payment.bankIssuer == bankIssuer ? Color.green : .clear)
                        .onTapGesture {
                            if self.payment.bankIssuer == bankIssuer {
                                self.payment.bankIssuer = nil
                            } else {
                                self.payment.bankIssuer = bankIssuer
                            }
                        }
                    }
                }
                
//                Picker("Medio de Pago", selection: $selectedBankIssuer) {
//                    Text("-")
//                        .tag(nil as BankIssuer?)
//                    ForEach(bankIssuers, id: \.self.id) {
//                        bankIssuer in
//
//                        Text(bankIssuer.name)
//
//                    }
//                }
//                .pickerStyle(.wheel)
                
                HStack {
                    Spacer()
                    NavigationLink("Continuar") {
                        SelectPaymentInstallmentsView()
                    }
                    .isDetailLink(false)
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.bankIssuer == nil)
                    .padding()
                }
                
                Spacer()
            }
            
        }
        .task {
            if let paymentMethod = payment.paymentMethod {
                await bankIssuers = apiServices.requestBankIssuers(paymentMethodId: paymentMethod.id)
            }
        }
    }
    
    
}

struct SelectBankIssuerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankIssuerView()
    }
}
