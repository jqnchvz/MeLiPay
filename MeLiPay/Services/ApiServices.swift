//
//  ApiServices.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 15-06-22.
//

import Foundation

class ApiServices: ObservableObject {
    
    // Servicios de acceso a datos a través de API pública de MercadoLibre.
    
    // Datos fijos. Reemplazar API Key personal para acceder a datos de MercadoLibre.
    private var apiKey = "API-KEY-GOES-HERE"
    
    private let baseUrl = "https://api.mercadopago.com/v1/payment_methods"
    
    // Solicitud de datos de métodos de pago disponibles.
    func requestPaymentMethods(errorHandler: ErrorHandler) async -> [PaymentMethod] {
        var paymentMethods: [PaymentMethod] = []
        
        if let requestUrl = URL(string: baseUrl + "?public_key=" + apiKey) {
            paymentMethods = await fetchAndDecode(requestUrl: requestUrl, errorHandler: errorHandler)
        }
        return paymentMethods
    }
    
    // Solicitud de datos de bancos emisores disponibles.
    func requestBankIssuers(paymentMethodId: String?, errorHandler: ErrorHandler) async -> [BankIssuer] {
        var bankIssuers: [BankIssuer] = []
        if let paymentMethodId = paymentMethodId {
            if let requestUrl = URL(string: baseUrl + "/card_issuers?" + "public_key=" + apiKey + "&payment_method_id=" + paymentMethodId) {
                bankIssuers = await fetchAndDecode(requestUrl: requestUrl, errorHandler: errorHandler)
            }
        }
        
        return bankIssuers
    }
    
    // Solicitud de datos de opciones de cuotas disponibles.
    func requestPaymentInstallments(amount: Int?, paymentMethodId: String?, bankIssuerId: String?, errorHandler: ErrorHandler) async -> [InstallmentsOption] {
        var installmentsOptions: [InstallmentsOptions] = []
        
        if let amount = amount, let paymentMethodId = paymentMethodId, let bankIssuerId = bankIssuerId {
            if let requestUrl = URL(string: baseUrl + "/installments?" + "public_key=" + apiKey
                                    + "&amount=\(amount)"
                                    + "&payment_method_id=" + paymentMethodId
                                    + "&issuer.id=" + bankIssuerId
            ) {
                installmentsOptions = await fetchAndDecode(requestUrl: requestUrl, errorHandler: errorHandler)
            }
        }
        
        if let installments = installmentsOptions.first?.payer_costs { // El resultado de la solicitud entrega arreglo con un item que tiene la info requerida.
            return installments
        }
        
        return []
    }
    
    // Funcion reutilizable para hacer la solicitud y decodificación de JSON con datos requeridos.
    private func fetchAndDecode<ItemType: Codable>(requestUrl: URL, errorHandler: ErrorHandler) async -> [ItemType] {
        var items: [ItemType] = []
        
        do {
            let (data, _) = try await URLSession.shared.data(from: requestUrl)
            let decodedData = try JSONDecoder().decode([ItemType].self, from: data)
            items = decodedData
        } catch {
            print("Error: \(error)")
            errorHandler.showErrorAlertWith(title: "Error", message: error.localizedDescription)
        }
        return items
    }
    
    func setApiKey(_ apiKey: String) {
        self.apiKey = apiKey
    }


}
