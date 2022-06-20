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
    
    // Variable para mostrar alerta con información personal.
    @State private var isShowingAboutMe = false
    
    // Variable para mostrar prompt de ingreso de llave pública de API.
    @State private var isShowingApiKeyPrompt = false
    
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
                    .disabled(payment.amount == 0 || apiServices.isApiKeyEmpty)
                    .padding()
                }
                
                // Mensaje de error si no se ha ingresado la llave pública para acceder a la API de MercadoLibre.
                if apiServices.isApiKeyEmpty {
                    Text("Ingresa tu API Key para poder continuar.")
                        .font(.title3)
                        .foregroundColor(.red)
                        
                }
                
                Spacer()
                
                
                
            }
            .navigationTitle("MeLiPay")
            // Botón que lanza alerta con info personal.
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Editar API Key") {
                            isShowingApiKeyPrompt = true
                        }
                        Button("Info") {
                            isShowingAboutMe = true
                        }
                }
            })
            .background(
                LinearGradient(gradient: Gradient(colors: [.teal, .white , .white, .white]), startPoint: .top, endPoint: .bottom)
                )
            
        }
        .onAppear {
            apiServices.loadApiKey() // Cargar APIKey guardada en Userdefaults.
            payment.resetPayment() // Resetear datos de pago cada vez que se carga esta vista inicial nuevamente.
            if apiServices.isApiKeyEmpty { // Si la API Key no se ha ingresado, mostrar prompt para ingresarla.
                isShowingApiKeyPrompt = true
            }
            
        }
        // Alerta con info personal.
        .alert("Info", isPresented: $isShowingAboutMe, actions: {}, message: {
                Text("Proyecto realizado por\nJoaquín Chávez B.\n Junio 2022")

        })
        // Sheet con solicitud de ingreso de llave pública para API de MercadoLibre.
        .sheet(isPresented: $isShowingApiKeyPrompt,
               onDismiss: {
                },
               content: {
                // Vista personalizada con formulario de ingreso de API Key.
                ApiKeyPromptView(apiServices: apiServices)
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
