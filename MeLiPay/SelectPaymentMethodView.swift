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
//    @ObservedObject var payment: Payment
    @State private var selectedPaymentType: PaymentType = .credit
//    @State private var selectedPaymentMethod = PaymentMethod()
    
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
                
                let paymentOptions = paymentMethods.filter {
                    $0.payment_type_id == selectedPaymentType.rawValue && payment.amount <= $0.max_allowed_amount
                }
                
                ScrollView {
                    
                    ForEach(paymentOptions, id: \.self.id) { paymentOption in
                        
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
                        .background(payment.paymentMethod == paymentOption ? Color.green : .clear)
                        .onTapGesture {
                            if self.payment.paymentMethod == paymentOption {
                                self.payment.paymentMethod = nil
                            } else {
                                self.payment.paymentMethod = paymentOption
                            }
                        }
                    }
                }
                
                
//                Picker("Medio de Pago", selection: $selectedPaymentMethod) {
//                    Text("-")
//                        .tag(nil as PaymentMethod?)
//                    ForEach(paymentOptions, id: \.self) {
//                        paymentOption in
//                        HStack {
//                            if let thumbnailUrl = URL(string: paymentOption.thumbnail) {
//                                AsyncImage(url: thumbnailUrl)
//                            }
//
//                            Text(paymentOption.name)
//                            Spacer()
//                        }
//
//                    }
//                }
//                .pickerStyle(.wheel)
//                .onChange(of: selectedPaymentMethod) { newValue in
//                    payment.paymentMethod = newValue
//                }
                
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
    }
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentMethodView()
    }
}
