//
//  SelectPaymentInstallmentsView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 17-06-22.
//

import SwiftUI

// Pantalla de selección de cuotas.

struct SelectPaymentInstallmentsView: View {
    
    @State private var installmentsOptions: [InstallmentsOption] = []
    
    @EnvironmentObject var payment: Payment
    
    @EnvironmentObject var apiServices: ApiServices
    
    @EnvironmentObject var errorHandler: ErrorHandler

    var body: some View {
        VStack(alignment: .leading) {
            PaymentSummaryView(payment: payment, summaryStyle: .minimal)
                .frame(height: 60, alignment: .topLeading)
            
            VStack(alignment: .leading) {
                Text("Selecciona la cantidad de cuotas: ")
                    .font(.headline)
                    .padding()
                
                // Vista multiuso reutilizada para selección de cuotas.
                CustomSelectionListView(items: installmentsOptions, selection: $payment.installments) { installmentsOption in
                    Text("\(installmentsOption.installments) x \(installmentsOption.formattedInstallmentAmount)")
                }
                
                HStack {
                    Text("Total a pagar: ")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(payment.installments?.formattedInstallmentTotalAmount ?? "-")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding([.leading, .trailing])
                
                HStack {
                    Spacer()
                    Button("Completar Pago") {
                        payment.paymentComplete = true  // Variable usada para verificar pago completado y mostrar resumen final.
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(payment.installments?.installments == nil)
                    .padding()
                }
                
                
                Spacer()
            }
        }
        .task {
            // Al cargar la vista actual se solicita la información de cuotas de manera asíncrona.
            installmentsOptions = await apiServices.requestPaymentInstallments(amount: payment.amount, paymentMethodId: payment.paymentMethod?.id, bankIssuerId: payment.bankIssuer?.id, errorHandler: errorHandler)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
        )
        .navigationTitle(Text("Cuotas"))
        .sheet(isPresented: $payment.paymentComplete, // Resumen final del pago. Aparece en formato Sheet y resetea los datos al hacer dismiss.
               onDismiss: {
                payment.paymentInProcess = false // Variable usada para hacer Pop-to-root, volviendo a pantalla inicial.
                },
               content: {
                FinalSummarySheetView(payment: payment)
        })
        // Alerta en caso de error al solicitar los datos desde la API.
        .alert(errorHandler.errorTitle, isPresented: $errorHandler.isShowingErrorAlert, actions: {}) {
            Text(errorHandler.errorMessage)
        }
        
    }
}

struct SelectPaymentInstallmentsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPaymentInstallmentsView()
    }
}
