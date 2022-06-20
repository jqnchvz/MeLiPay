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

// Pantalla de selección de Medio de Pago.

struct SelectPaymentMethodView: View {
    
    @State private var paymentMethods: [PaymentMethod] = []
    @State private var selectedPaymentType: PaymentType = .credit

    @EnvironmentObject var payment: Payment
    @EnvironmentObject var apiServices: ApiServices
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // Vista con resumen de datos de pago.
            PaymentSummaryView(payment: payment, summaryStyle: .minimal) // Vista resumen de pago reutilizable.
                .frame(height: 60, alignment: .topLeading)
            
            Text("Selecciona un método de pago")
                .font(.headline)
                .padding()
            
            VStack {
                // Selector para filtrar lista de opciones según por tipo de pago.
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
                
                // Lista de opciones filradas según selección anterior.
                let paymentOptions = paymentMethods.filter {
                    $0.payment_type_id == selectedPaymentType.rawValue && payment.amount <= $0.max_allowed_amount
                }
                
                // Si la lista filtrada está vacía mostrar mensaje.
                if paymentOptions.isEmpty {
                    VStack{
                        Text("No hay opciones de pago disponibles.")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Intenta con un monto menor.")
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .padding()
                }
                
                // Vista personalizada reutilizable con lista de opciones a mostrar.
                CustomSelectionListView(items: paymentOptions, selection: $payment.paymentMethod) { paymentOption in
                    
                    // Vista personalizada reutilizable para estilizar cada opción a mostrar.
                    ListItemWithThumbnail(text: paymentOption.name, thumbnailUrlString: paymentOption.secure_thumbnail)
                }
                
                // Botón para seguir proceso de pago.
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
            // Al cargar la vista actual se solicita la información de metodos de pago de manera asíncrona.
            paymentMethods = await apiServices.requestPaymentMethods(errorHandler: errorHandler)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
            )
        .navigationBarTitle(Text("Medio de Pago"))
        // Alerta en caso de error al solicitar los datos desde la API.
        .alert(errorHandler.errorTitle, isPresented: $errorHandler.isShowingErrorAlert, actions: {}) {
            Text(errorHandler.errorMessage)
        }
    }
}

struct SelectPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentMethodView()
    }
}
