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
            PaymentSummaryView(payment: payment)
            
            VStack(alignment: .leading) {
                
                Text("Selecciona la cantidad de cuotas: ")
                    .padding()
                
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
                .padding()
                
                HStack {
                    Spacer()
                    NavigationLink("Completar Pago") {
                        
                    }
                    .isDetailLink(false)
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.installments?.installments == nil)
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
