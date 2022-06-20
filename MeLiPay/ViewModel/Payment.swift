//
//  Payment.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 14-06-22.
//

import Foundation
import CurrencyFormatter
protocol PaymentData: Identifiable, Equatable {
}

class Payment: ObservableObject {
    // Monto a pagar en Double.
    @Published var amountDouble: Double? = 0.0 {
        // Cada vez que se ingresa un nuevo monto, resetear método de pago seleccionado.
        didSet {
            paymentMethod = nil
        }
    }
    // Computed property para usar monto a pagar como Int.
    var amount: Int {
        Int(amountDouble ?? 0.0)
    }
    
    // Método de pago seleccionado, como crédito, débito, ticket y el método específico (Visa, Mastercard, Maestro, etc.))
    @Published var paymentMethod: PaymentMethod? {
        // Cada vez que se cambia un nuevo método de pago asegurarse de resetear banco emisor.
        didSet {
            bankIssuer = nil
        }
    }
    // Banco emisor del medio de pago seleccionado.
    @Published var bankIssuer: BankIssuer? {
        // Cada vez que se cambia un nuevo banco emisor asegurarse de resetear cuotas.
        didSet {
            installments = nil
        }
    }
    
    // Tipo de cuotas seleccionadas.
    @Published var installments: InstallmentsOption?
    
    
    // Variables para controlar flujo de pago
    // Indicacador de pago en proceso pero no terminado.
    @Published var paymentInProcess = false //Sirve para hacer Pop-to-root en NavigationView.
    // Confirmación de pago completado.
    @Published var paymentComplete = false // Sirve para mostrar sheet con resumen final.
    
    // Referencia a formateador de monedas.
    @Published var currencyFormatter = CurrencyFormatter.default
    
    // Variable computada para obtener String de monto a pagar formateado como moneda.
    var formattedAmount: String {
        
        if let amountDouble = amountDouble {
            return currencyFormatter.string(from: amountDouble) ?? "-"
        }
        return "-"
    }
    
    // Resetear datos de pago.
    func resetPayment() {
        amountDouble = nil
        paymentMethod = nil
        bankIssuer = nil
        installments = nil
        paymentInProcess = false
        paymentComplete = false
    }
  
}

// Configuración de formateador de monedas.
private extension CurrencyFormatter {
    static let `default`: CurrencyFormatter = {
        .init {
            $0.currency = .chileanPeso
            $0.locale = CurrencyLocale.spanishChile
            $0.hasDecimals = false
            $0.minValue = 1
            $0.maxValue = 100000000
        }
    }()
}
