//
//  CurrencyTextfieldView.swift
//  MeLiPay
//
//  Created by Joaquín Chávez on 20-06-22.
//

import SwiftUI

import CurrencyFormatter
import CurrencyTextField

// Vista para generar TextField formateado como moneda para ingreso de monto a pagar.
struct CustomCurrencyTextFieldView: View {
    
    @ObservedObject var payment: Payment
    
    // Variables para operación de CurrencyTextField
    @State private var hasFocus: Bool? = false
    @State private var shouldClearTextField = true
    @State private var currency: Currency = .chileanPeso
    @State private var inputText: String = ""
    @State private var unformattedInputText: String?
    
    var body: some View {
        // Campo de texto creado usando la librería externa CurrencyText.
        makeCurrencyTextField()
            .shadow(radius: 5)
            .padding()
            .onAppear {
                inputText = ""
            }
    }
    
    // Configuración de TextField según documentación de librería CurrencyText.
    private func makeCurrencyTextField() -> some View {
        CurrencyTextField(
            configuration: .init(
                placeholder: "$0",
                text: $inputText,
                unformattedText: $unformattedInputText,
                inputAmount: $payment.amountDouble,
                hasFocus: $hasFocus,
                clearsWhenValueIsZero: false,
                formatter: $payment.currencyFormatter,
                textFieldConfiguration: { uiTextField in
                    uiTextField.borderStyle = .roundedRect
                    uiTextField.font = UIFont.systemFont(ofSize: 60)
                    uiTextField.layer.cornerRadius = 5
                    uiTextField.layer.masksToBounds = true
                    uiTextField.keyboardType = .numberPad
                    uiTextField.frame.size.width = 300
                    uiTextField.adjustsFontSizeToFitWidth = true
                    uiTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                },
                onEditingChanged: { _ in
                },
                onCommit: {
                }
            )
        )
        .disabled(false)
    }
    
}



struct CustomCurrencyTextfieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCurrencyTextFieldView(payment: Payment())
    }
}
