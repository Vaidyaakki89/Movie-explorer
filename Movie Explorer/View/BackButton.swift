//
//  SwiftUIView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 11/07/25.
//



import SwiftUI

struct BackButton: View{
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
       
            
            Button(action: {
              
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "arrow.backward")
                       // .renderingMode(.template)
                      //  .foregroundColor(.white)
                       // .resizable().frame(width: 28, height: 25)
                      .padding(.trailing, 60)
                        .padding(.vertical, 10)
             // .border(.red)
                    Text("")
                }
            }
          
            
        
        
    }
}

