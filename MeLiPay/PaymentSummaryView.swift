//
//  PaymentSummaryView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 18-06-22.
//

import SwiftUI

struct PaymentSummaryView: View {
    @ObservedObject var payment: Payment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Resumen")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading)
            
            HStack(alignment: .top){
                Text("Monto:\n$\(payment.amount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding([.leading, .trailing])
                
                Text("Medio de Pago:\n\(payment.paymentMethod?.name ?? "N/A")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding([.leading, .trailing])
                
                Text("Emisor:\n\(payment.bankIssuer?.name ?? "N/A")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding([.leading, .trailing])
                
                Text("Nº Cuotas:\n\(payment.installments?.installments ?? 0)")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
