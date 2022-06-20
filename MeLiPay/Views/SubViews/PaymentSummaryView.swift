//
//  PaymentSummaryView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 18-06-22.
//

import SwiftUI

// Estilos de resumen disponibles.
enum SummaryStyle {
    case minimal, regular
}

// Vista personalizada multiuso para generar resumen con datos de pago.

struct PaymentSummaryView: View {
    @ObservedObject var payment: Payment
    // Variable que setea estilo deseado.
    var summaryStyle: SummaryStyle = .minimal
    
    var body: some View {
        // Dos opciones de vista a mostrar según valor de summaryStyle
        if summaryStyle == .minimal {
            // Vista en formato horizontal para resumen durante proceso de pago.
            VStack(alignment: .leading, spacing: 10) {
                Text("Resumen")
                    .font(.caption2)
//                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                HStack(alignment: .top){
                    Text("Monto:\n\(payment.formattedAmount)")
                        .font(.caption2)
//                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing])
                    
                    Text("Medio:\n\(payment.paymentMethod?.name ?? "N/A")")
                        .font(.caption2)
//                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing])
                    
                    Text("Emisor:\n\(payment.bankIssuer?.name ?? "N/A")")
                        .font(.caption2)
//                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing])
                    
                    Text("Nº Cuotas:\n\(payment.installments?.installments ?? 0)")
                        .font(.caption2)
//                        .foregroundColor(.secondary)
                        .padding([.leading, .trailing])
                }
            }
        } else {
            // Vista de distribución vertical. Para uso en resumen final.
            VStack(alignment: .leading, spacing: 30){
                Text("Resumen")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                Text("Monto:\n\(payment.formattedAmount)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.leading, .trailing])
                
                Text("Medio:\n\(payment.paymentMethod?.name ?? "N/A")")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.leading, .trailing])
                
                Text("Emisor:\n\(payment.bankIssuer?.name ?? "N/A")")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.leading, .trailing])
                
                Text("Nº Cuotas:\n\(payment.installments?.installments ?? 0)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.leading, .trailing])
                
                Text("Total a pagar:\n \(payment.installments?.formattedInstallmentTotalAmount ?? "-")")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding([.leading, .trailing])
                
            }
        }
    }
}

struct PaymentSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSummaryView(payment: Payment())
    }
}
