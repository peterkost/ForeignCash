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
    @State private var type = "Personal"
    @State private var amountString = ""
    @State private var invalidAmount = false
    
    static let types = ["Personal", "Buisness"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $title)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amountString)
                    .keyboardType(.decimalPad)
            }
            .navigationBarTitle("Add Transaction")
            .navigationBarItems(trailing: Button("Save") {
                transactions.addTransaction(title: title, descirption: description, amount: Double(amountString)!, type: type)
                presentationMode.wrappedValue.dismiss()
            })
//            .alert(isPresented: $invalidAmount, content: {
//                Alert(title: Text("Invalid Amount"), message: Text("Please enter a valid intiger."), dismissButton: .default(Text("Dismiss")))
//            })
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
