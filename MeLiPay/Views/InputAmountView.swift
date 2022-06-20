//
//  InputAmount.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import SwiftUI

// Pantalla inicial para ingreso de monto a pagar.
struct InputAmountView: View {
    // Modelo de pago
    @StateObject var payment = Payment()
    
    // Acceso a servicios API
    @StateObject var apiServices = ApiServices()
    
    // Manejo de errores
    @StateObject var errorHandler = ErrorHandler()
    
    // Variable para mostrar alerta con información.
    @State private var isShowingAboutMe = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ingresa un monto a pagar")
                    .font(.headline)
                    .padding()
                
                // Campo de texto personalizado para ingreso de valores en formato de moneda.
                CustomCurrencyTextFieldView(payment: payment)
                
                // Botón para continuar  proceso
                HStack {
                    Spacer()
                    NavigationLink("Continuar", destination: SelectPaymentMethodView(), isActive: $payment.paymentInProcess) // variable isActive permite hacer Pop-to-Root alfinal del proceso de pago.
                        .isDetailLink(false)
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.amount == 0)
                    .padding()
                }
                
                Spacer()
                
            }
            .navigationTitle("MeLiPay")
            // Botón que lanza alerta con info personal.
            .toolbar(content: {
                Button("Info") {
                    isShowingAboutMe = true
                }
            })
            .background(
                LinearGradient(gradient: Gradient(colors: [.teal, .white , .white, .white]), startPoint: .top, endPoint: .bottom)
                )
            
        }
        .onAppear {
            payment.resetPayment() // Resetear datos de pago cada vez que se carga esta vista inicial nuevamente.
        }
        // Alerta con info personal.
        .alert("Info", isPresented: $isShowingAboutMe, actions: {}, message: {
                Text("Proyecto realizado por\nJoaquín Chávez B.\n Junio 2022")

        })
        .environmentObject(payment)
        .environmentObject(apiServices)
        .environmentObject(errorHandler)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InputAmountView()
    }
}
