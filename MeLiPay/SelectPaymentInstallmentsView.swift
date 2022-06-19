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
    
    @Environment(\.presentationMode) private var presentationMode
    
    let apiServices = ApiServices()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            PaymentSummaryView(payment: payment, summaryStyle: .minimal)
                .frame(height: 60, alignment: .topLeading)
            
            VStack(alignment: .leading) {
                
                Text("Selecciona la cantidad de cuotas: ")
                    .font(.headline)
                    .padding()
                
                ScrollView {
                    
                    ForEach(installmentsOptions, id: \.self.installments) { installmentsOption in
                        Button {
                            if self.payment.installments == installmentsOption {
                                self.payment.installments = nil
                            } else {
                                self.payment.installments = installmentsOption
                            }
                        } label : {
                            HStack {
                                Text("\(installmentsOption.installments) x \(installmentsOption.formattedInstallmentAmount)")
                                Spacer()
                                
                                if payment.installments == installmentsOption {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.white)
                                        .padding()
                                }
                            }
                            .frame(height: 50)
                            .padding([.leading, .trailing])
                            .background(payment.installments == installmentsOption ? Color.green : .clear)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding()
                HStack {
                    Text("Total a pagar: ")
                        .font(.headline)
                    Text(payment.installments?.formattedInstallmentTotalAmount ?? "-")
                        .font(.headline)
                }
                .padding([.leading, .trailing])
                
                HStack {
                    Spacer()
                    Button("Completar Pago") {
                        payment.paymentInProcess = false // Variable usada para hacer Pop-to-root.
                        payment.paymentComplete = true  // Variable usada para verificar pago completado.
                    }
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
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
            )
        .navigationTitle(Text("Cuotas"))
        
    }
}

struct SelectPaymentInstallmentsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentInstallmentsView()
    }
}
