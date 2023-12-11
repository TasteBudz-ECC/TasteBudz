//
//  NewGatheringViewViewModel.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/8/23.
//
import Foundation
class NewGatheringViewViewModel: ObservableObject{
    @Published var title = ""
    @Published var dueDate = Date () //date is initialized to the current date and time
    
    init() {
        //implemented on NewGatheringView
        func post() {
            
        }
        
    }
}

