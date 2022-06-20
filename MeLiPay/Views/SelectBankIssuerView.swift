//
//  SelectBankIssuerView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 16-06-22.
//

import SwiftUI

// Pantalla de selección de Bancos Emisores.

struct SelectBankIssuerView: View {
    
    @State private var bankIssuers: [BankIssuer] = []

    @EnvironmentObject var payment: Payment
    @EnvironmentObject var apiServices: ApiServices
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var body: some View {
        VStack(alignment: .leading) {
            // Vista resumen reutilizable
            PaymentSummaryView(payment: payment, summaryStyle: .minimal)
                .frame(height: 60, alignment: .topLeading)
            
            Text("Selecciona un emisor")
                .font(.headline)
                .padding()
            
            // Vista multiuso reutilizada para selección de emisores.
            CustomSelectionListView(items: bankIssuers, selection: $payment.bankIssuer) { bankIssuer in
                // Vista personalizada reutilizable para estilizar cada opción a mostrar.
                ListItemWithThumbnail(text: bankIssuer.name, thumbnailUrlString: bankIssuer.secure_thumbnail)
            }
            
            // Botón para seguir proceso de pago.
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
            // Al cargar la vista actual se solicita la información de bancos emisores de manera asíncrona.
            bankIssuers = await apiServices.requestBankIssuers(paymentMethodId: payment.paymentMethod?.id, errorHandler: errorHandler)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.teal, .white, .white]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle(Text("Emisor"))
        // Alerta en caso de error al solicitar los datos desde la API.
        .alert(errorHandler.errorTitle, isPresented: $errorHandler.isShowingErrorAlert, actions: {}) {
            Text(errorHandler.errorMessage)
        }
}


}

struct SelectBankIssuerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBankIssuerView()
    }
}
