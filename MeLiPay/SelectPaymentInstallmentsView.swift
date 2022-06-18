//
//  SelectPaymentInstallmentsView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 17-06-22.
//

import SwiftUI

struct SelectPaymentInstallmentsView: View {
    @State private var installmentsOptions: [InstallmentsOption] = []
    
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
            
            
            VStack {
                
                Text("Selecciona la cantidad de cuotas: ")
                ScrollView {
                    
                    ForEach(installmentsOptions, id: \.self.installments) { installmentsOption in
                        
                        HStack {
                            Text(installmentsOption.recommended_message)
                            Spacer()
                            
                            if payment.installments == installmentsOption {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                        .frame(height: 50)
                        .background(payment.installments == installmentsOption ? Color.green : .clear)
                        .onTapGesture {
                            if self.payment.installments == installmentsOption {
                                self.payment.installments = nil
                            } else {
                                self.payment.installments = installmentsOption
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    NavigationLink("Completar Pago") {
                        
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
            if let paymentMethod = payment.paymentMethod, let bankIssuer = payment.bankIssuer {
                await installmentsOptions = apiServices.requestPaymentInstallments(amount: payment.amount, paymentMethodId: paymentMethod.id, bankIssuerId: bankIssuer.id) ?? []
            }
        }
        .navigationTitle(Text("Cuotas"))
        
    }
}

struct SelectPaymentInstallmentsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentInstallmentsView()
    }
}
