//
//  SearchView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 11/07/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel:MovieViewModel
    var body: some View {
        VStack{
            HStack{
                TextField("search", text: $viewModel.searchTxt)
                
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15,height: 15)
                    .padding(.trailing, 10)
                    .onTapGesture {
                        viewModel.searchTxt.removeAll()
                        viewModel.createSearchList()
                    }
                
            }
                .onChange(of: viewModel.searchTxt, {
                    viewModel.createSearchList()
                    
                })
//                .onChange(of: viewModel.searchTxt, perform: {_ in
//                   
//                    
//                })
               
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color(hex: "#075985" ), lineWidth: 1))
               
                .padding(16)
            
            
            List(viewModel.searchList, id: \.self){movie in
                
                MovieCardView(movie: movie, viewModel: viewModel)
                    .onAppear(){
                       // viewModel.loadMoreContent(obj: movie)
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            Spacer()
        }
    }
}

#Preview {
    SearchView()
}
