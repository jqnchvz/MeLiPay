//
//  InstallmentsOptions.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 17-06-22.
//

import Foundation

// Modelo para opciones de cuotas según datos obtenidos desde API de MercadoLibre.
struct InstallmentsOptions: Codable, Equatable {
    let payment_method_id: String
    let payment_type_id: String
    let issuer: BankIssuer
    let payer_costs: [InstallmentsOption]
}

struct InstallmentsOption: Codable, Equatable, PaymentData {
    let id = UUID()
    let installments: Int
    let installment_rate: Double
    let installment_amount: Double
    let total_amount: Double
    let recommended_message: String
    
    // Variable computada para obtener String de valor de cada cuota formateado como moneda.
    var formattedInstallmentAmount: String {
        let formatter = NumberFormatter()
            formatter.numberStyle = .currency

        return formatter.string(from: NSNumber(value: installment_amount)) ?? "$0"
    }
    
    // Variable computada para obtener String de valor de monto total a pagar formateado como moneda.
    var formattedInstallmentTotalAmount: String {
        let formatter = NumberFormatter()
            formatter.numberStyle = .currency

        return formatter.string(from: NSNumber(value: total_amount)) ?? "$0"
    }
}
