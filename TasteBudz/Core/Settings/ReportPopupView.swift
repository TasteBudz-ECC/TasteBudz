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
                .fixedSize(horizontal: false, vertical: true)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            Button("Submit") {
                addReportToFirebase(desc: self.description)
                // Add code to handle the submission
                // You can access the description using self.description
                // For now, let's just dismiss the popup
                self.isPresented = false
            }
            .foregroundColor(.blue)
            // You can add more UI components as needed
            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
    
    //handlesubmitbutton() defined for when submit button is pressed
    //Goal: To send data over to Firebase
    //    private func handleSubmitButton() {
    //        // Add your code to handle the submission
    //        // For example, you can print the description for now
    //        print("Description submitted: \(description)")
    //
    //        addReportToFirebase(desc:String)
    //
    //    }
    
    func addReportToFirebase(desc:String){
        
        print("Description submitted: \(desc)")
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = formatter.string(from: currentDate)
        
        let db = Firestore.firestore()
        //create structure for firebase
        
        let reportData = [
            "description": description,
            "date": formattedDate,
            "userID": Auth.auth().currentUser?.uid.description,
        ] as [String : Any]
        
        print(reportData)
        
        //add new data point, no error will occur, no try catch is needed in this operation with no specific document
        db.collection("reports").addDocument(data: reportData)
        
    }
}
