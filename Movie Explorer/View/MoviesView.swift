//
//  MoviesView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 10/07/25.
//

import SwiftUI

struct MoviesView: View {
    
    @EnvironmentObject var viewModel:MovieViewModel
    
    var body: some View {
        VStack{
            
            List(viewModel.moviesList, id: \.self){movie in
                
                MovieCardView(movie: movie, viewModel: viewModel)
                    .onAppear(){
                        viewModel.loadMoreContent(obj: movie)
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
      
    }
}

#Preview {
    MoviesView()
}
