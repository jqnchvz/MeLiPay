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
            
            PaymentSummaryView(payment: payment, summaryStyle: .minimal)
                .frame(height: 60, alignment: .topLeading)
            
            Text("Selecciona un emisor")
                .font(.headline)
                .padding()
            
            ScrollView {
                
                ForEach(bankIssuers, id: \.self.id) { bankIssuer in
                    Button {
                        if self.payment.bankIssuer == bankIssuer {
                            self.payment.bankIssuer = nil
                        } else {
                            self.payment.bankIssuer = bankIssuer
                        }
                    } label: {
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
                        .padding([.leading, .trailing])
                        .background(payment.bankIssuer == bankIssuer ? Color.green : .clear)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .padding()
            
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
        .task {
            if let paymentMethod = payment.paymentMethod {
                await bankIssuers = apiServices.requestBankIssuers(paymentMethodId: paymentMethod.id)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle(Text("Emisor"))
}


}

struct SelectBankIssuerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankIssuerView()
    }
}
