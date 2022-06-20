//
//  FinalSummarySheetView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 20-06-22.
//

import SwiftUI

// Vista de resumen de pago final.
struct FinalSummarySheetView: View {
    @Environment(\.presentationMode) var presentationMode
    var payment: Payment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Pago Realizado")
                .font(.largeTitle)
            // Vista resumen de pago reutilizable.
            PaymentSummaryView(payment: payment, summaryStyle: .regular)
            
            Button("Comenzar nuevo pago") {
                // Variable usada para hacer Pop-to-root en NavigatioView, volviendo a pantalla inicial.
                payment.paymentInProcess = false
                // Hacer dismiss en el sheet.
                presentationMode.wrappedValue.dismiss()
            }
        .buttonStyle(.borderedProminent)
        }
    }
}

struct FinalSummarySheetView_Previews: PreviewProvider {
    static var previews: some View {
        FinalSummarySheetView(payment: Payment())
    }
}
