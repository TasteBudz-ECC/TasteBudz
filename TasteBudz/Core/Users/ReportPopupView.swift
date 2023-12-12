//
//  ReportPopupView.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/7/23.
//
// ReportPopupView.swift
import SwiftUI
import FirebaseFirestore
import Firebase
struct ReportPopupView: View {
    @Binding var isPresented: Bool
    @State private var description: String = ""
    var body: some View {
        VStack {
            Text("Please Describe the Issue in Detail")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Submit") {
                handleSubmitButton()
                // Add code to handle the submission
                // You can access the description using self.description
                // For now, let's just dismiss the popup
                self.isPresented = false
            }
            .padding()
            .foregroundColor(.black)
            // You can add more UI components as needed
            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
    //handlesubmitbutton() defined for when submit button is pressed
    //Goal: To send data over to Firebase
    private func handleSubmitButton() {
        // Add your code to handle the submission
        // For example, you can print the description for now
        print("Description submitted: \(description)")
        
        //Devin's code
        func addPOItoFirebase(date:String, desc:String, docid: String, type:String){
            
            let db = Firestore.firestore()
            //create structure for firebase
            
            let newPoi = [
                "date":date,
                "description":desc,
                "docid": db.collection("gatherings"),
                "type":type,
            ] as [String : Any]
            
            print(newPoi)
            
            //add new data point, no error will occur, no try catch is needed in this operation with no specific document
            db.collection("reports").addDocument(data: newPoi)
            
        }
        
        //END of Devin's code
    }
}
