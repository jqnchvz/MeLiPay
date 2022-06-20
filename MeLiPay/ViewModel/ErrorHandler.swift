//
//  ErrorHandler.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 20-06-22.
//

import Foundation

// Manejador de errores.
class ErrorHandler: ObservableObject {
    // Datos de error a mostrar.
    var errorTitle = ""
    var errorMessage = ""
    
    // Variable que permite mostrar Alerta con datos de error donde corresponda.
    @Published var isShowingErrorAlert = false
    
    // Función para setear título, mensaje y activar alerta de error.
    func showErrorAlertWith(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        isShowingErrorAlert = true
    }
    
}
