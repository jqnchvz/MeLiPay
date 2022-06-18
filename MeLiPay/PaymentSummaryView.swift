//
//  PaymentSummaryView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 18-06-22.
//

import SwiftUI

struct PaymentSummaryView: View {
    var payment: Payment
    
    var body: some View {
        
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
    }
}

struct PaymentSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSummaryView(payment: Payment())
    }
}
