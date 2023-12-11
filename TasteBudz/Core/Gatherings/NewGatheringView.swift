//
//  NewGatheringView.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/7/23.
//
import SwiftUI
struct NewGatheringView: View {
    @StateObject var viewModel = NewGatheringViewViewModel()
    @State private var description: String = ""
    
    var body: some View {
        VStack{
            Text("New Gathering")
                .font(.system(size: 32))
                .bold()
            Form {
                //Title
                TextField("Restaurant Name", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                //Due date --> Propose date and time to meet
                DatePicker("Date and Time", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                //Additional Details
                TextField(text: $description, prompt: Text("Description")) { Text("Description")
                }
                
                //Button //resume at 1.36.09
                NGButton(title: "Request Gather", background: .pink) {
                    //this will trigger somthing in the viewModel
                    //viewModel.post()
                }
                .padding()
                
            }
        }
    }
    
}
struct NewGatheringView_Previews: PreviewProvider {
    static var previews: some View {
        NewGatheringView()
    }
}
