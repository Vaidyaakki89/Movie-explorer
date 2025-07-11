//
//  MovieCardView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 10/07/25.
//

import SwiftUI
import Kingfisher

struct MovieCardView: View {
    let movie:Result
    @StateObject var viewModel = MovieViewModel()
    @State var navigateToDetails = false
    
    var body: some View {
        
        VStack{
            
            Button(action: {
                navigateToDetails = true
            }, label: {
                
                
                HStack{
                    KFImage(URL(string: "\(APIConstants.posterURL)\(movie.posterPath ?? "")"))
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .scaledToFill()
                                .frame(width: 80,height: 80)
                                .clipped()
                            
                        }
                        .resizable()
                    
                        .scaledToFill()
                        .frame(width: 80,height: 80)
                        .clipped()
                    
                    VStack(alignment: .leading){
                        Text(movie.title ?? "")
                        Text(movie.releaseDate ?? "")
                        Text(String(format: "%.2f", movie.voteAverage ?? 0))
                    }
                    
                    Spacer()
                    
                    VStack{
                        Image(systemName:  (viewModel.favouriteMovieDict[movie.id ?? 0] ?? false)  ? "heart.fill" :"heart")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor((viewModel.favouriteMovieDict[movie.id ?? 0] ?? false) ? .red :.gray)
                            .scaledToFill()
                            .frame(width: 25,height: 25)
                            .padding(.top, 10)
                            .onTapGesture {
                                if  ((viewModel.favouriteMovieDict[movie.id ?? 0] ?? false) == false){
                                    viewModel.favouriteMovieDict[movie.id ?? 0] = true
                                    // viewModel.favouriteList.append(movie)
                                    viewModel.addToDatabase(movie: movie)
                                   viewModel.triggerNotification(message: "\(movie.title ?? "") is marked as your favourite movie.", title: movie.title ?? "")
                                }else{
                                    
                                    viewModel.favouriteMovieDict[movie.id ?? 0] = false
                                    DispatchQueue.main.async{
                                        viewModel.removeDataFromFavourite(movie1: movie)
                                    }
//                                    viewModel.favouriteList.removeAll(where: {item in
//                                                   item == movie
//                                               })
                                 
                                }
                            }
                        
                        Spacer()
                        
                    }
                }
            })
        }.navigationDestination(isPresented: $navigateToDetails, destination: {
            MovieDetailsView(movie: movie, viewModel: viewModel)
        })
    }
}

//#Preview {
//    MovieCardView()
//}
