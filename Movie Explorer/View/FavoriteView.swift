//
//  FavoriteView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 10/07/25.
//

import SwiftUI

struct FavoriteView: View {
    
    @EnvironmentObject var viewModel:MovieViewModel
    
    var body: some View {
        VStack{
          //  if viewModel.isUpdated{
                List(viewModel.favouriteList, id: \.self){movie in
                    
                    MovieCardView(movie: movie, viewModel: viewModel)
                    
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
//            }
//            else{
//                
//                List(viewModel.favouriteList, id: \.self){movie in
//                    
//                    MovieCardView(movie: movie, viewModel: viewModel)
//                    
//                        .listRowSeparator(.hidden)
//                }
//                .listStyle(.plain)
//            }
        }
     
        
    }
}

#Preview {
    FavoriteView()
}
