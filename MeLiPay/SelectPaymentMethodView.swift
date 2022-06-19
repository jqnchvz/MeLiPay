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
    @State private var selectedPaymentType: PaymentType = .credit
    
    @EnvironmentObject var payment: Payment
    
    let apiServices = ApiServices()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            PaymentSummaryView(payment: payment, summaryStyle: .minimal)
                .frame(height: 60, alignment: .topLeading)
            
            Text("Selecciona un método de pago")
                .font(.headline)
                .padding()
            
            VStack {
                
                Picker("Tipo de pago", selection: $selectedPaymentType) {
                    ForEach(PaymentType.allCases, id: \.self) { paymentType in
                            switch paymentType {
                            case .credit:
                                Text("Crédito")
                            case .debit:
                                Text("Débito")
                            default:
                                Text("Ticket")
                            }
                    }
                }
                .pickerStyle(.segmented)
                .padding([.leading, .trailing])
                
                let paymentOptions = paymentMethods.filter {
                    $0.payment_type_id == selectedPaymentType.rawValue && payment.amount <= $0.max_allowed_amount
                }
                
                ScrollView {
                    
                    ForEach(paymentOptions, id: \.self.id) { paymentOption in
                        Button {
                            if self.payment.paymentMethod == paymentOption {
                                self.payment.paymentMethod = nil
                            } else {
                                self.payment.paymentMethod = paymentOption
                            }
                            payment.bankIssuer = nil
                        } label: {
                            HStack {
                                if let thumbnailUrl = URL(string: paymentOption.secure_thumbnail) {
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
                                Text(paymentOption.name)
                                Spacer()
                                
                                if payment.paymentMethod == paymentOption {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.white)
                                        .padding()
                                }
                            }
                            .frame(height: 50)
                            .padding([.leading, .trailing])
                            .background(payment.paymentMethod == paymentOption ? Color.green : .clear)
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
                        SelectBankIssuerView()
                    }
                    .isDetailLink(false)
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.paymentMethod == nil)
                    .padding()
                    
                }
                
                Spacer()
            }
            
            
            
        }
        .task {
            await paymentMethods = apiServices.requestPaymentMethods()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
            )
        .navigationBarTitle(Text("Medio de Pago"))
    }
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentMethodView()
    }
}
