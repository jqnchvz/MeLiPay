//
//  PaymentSummaryView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 18-06-22.
//

import SwiftUI

enum SummaryStyle {
    case minimal, regular
}

struct PaymentSummaryView: View {
    @ObservedObject var payment: Payment
    var summaryStyle: SummaryStyle = .minimal
    var summaryStyleToggle: Bool {
        summaryStyle == .minimal
    }
    
    var body: some View {
        
        if summaryStyle == .minimal {
            VStack(alignment: .leading, spacing: 10) {
                Text("Resumen")
                    .font(summaryStyleToggle ? .caption2 : .largeTitle)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                HStack(alignment: .top){
                    Text("Monto:\n$\(payment.formattedAmount)")
                        .font(summaryStyleToggle ? .caption2 : .headline)
                        .foregroundColor(summaryStyleToggle ? .secondary : .primary)
                        .padding([.leading, .trailing])
                    
                    Text("Medio:\n\(payment.paymentMethod?.name ?? "N/A")")
                        .font(summaryStyleToggle ? .caption2 : .headline)
                        .foregroundColor(summaryStyleToggle ? .secondary : .primary)
                        .padding([.leading, .trailing])
                    
                    Text("Emisor:\n\(payment.bankIssuer?.name ?? "N/A")")
                        .font(summaryStyleToggle ? .caption2 : .headline)
                        .foregroundColor(summaryStyleToggle ? .secondary : .primary)
                        .padding([.leading, .trailing])
                    
                    Text("Nº Cuotas:\n\(payment.installments?.installments ?? 0)")
                        .font(summaryStyleToggle ? .caption2 : .headline)
                        .foregroundColor(summaryStyleToggle ? .secondary : .primary)
                        .padding([.leading, .trailing])
                }
            }
        } else {
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
