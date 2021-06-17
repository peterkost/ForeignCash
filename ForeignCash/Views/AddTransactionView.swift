//
//  AddTransactionView.swift
//  ForeignCash
//
//  Created by Peter Kostin on 2021-06-17.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var transactions: Transactions
    
    @State private var title = ""
    @State private var description = ""
    @State private var type = "Spend"
    @State private var forexAmountString = ""
    @State private var homeAmountString = ""
    
    @State private var invalidAmount = false
    @State private var alertMessage = ""
    
    let types = ["Spend", "Add"]
    
    var body: some View {
        NavigationView {
            List {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("Merchant Name", text: $title)
                
                TextField("Description", text: $description)
                
                if type == "Add" {
                    TextField("CAD spent", text: $homeAmountString)
                        .keyboardType(.decimalPad)
                }
                
                TextField(type == "Add" ? "RUB recieved" : "RUB spent", text: $forexAmountString)
                    .keyboardType(.decimalPad)

            }
            .navigationBarTitle("New Transaction")
            .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "xmark")
            },
            trailing:
                Button(action: addTransaction) {
                    Image(systemName: "checkmark")
                })
            .alert(isPresented: $invalidAmount, content: {
                Alert(title: Text("Invalid Transaction"), message: Text(alertMessage), dismissButton: .default(Text("Dismiss")))
            })
        }
    }
    
    func addTransaction() {
        guard let forexAmount = Double(forexAmountString) else {
            alertMessage = "Please enter a valid RUB amount."
            invalidAmount = true
            return
        }
        
        if type == "Add" {
            guard let homeAmount = Double(homeAmountString) else {
                alertMessage = "Please enter a valid CAD amount."
                invalidAmount = true
                return
            }
            transactions.addTransaction(title: title, descirption: description, type: type, forexAmount: forexAmount, homeAmount: homeAmount)
            presentationMode.wrappedValue.dismiss()
            return
        }
        
        transactions.addTransaction(title: title, descirption: description, type: type, forexAmount: forexAmount)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
