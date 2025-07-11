//
//  MovieDetailsView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 11/07/25.
//



import SwiftUI
import Kingfisher
struct MovieDetailsView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let movie:Result
    @StateObject var viewModel = MovieViewModel()
   @State var navigateToTrailer = false
    
    var body: some View {
        
        
        
     
            
            VStack{
        
                    
                    ScrollView{
                        
                        VStack{
                            KFImage(URL(string: "\(APIConstants.posterURL)\(viewModel.movieDetails?.backdropPath ?? "")"))
                                .resizable()
                        
                                .scaledToFill()
                                .frame(width: screenWidth,height: 300)
                                .clipped()
                                .padding(.trailing, 5)
                            
                            
                            HStack(alignment: .bottom,spacing: 10){
                                
                                KFImage(URL(string: "\(APIConstants.posterURL)\(viewModel.movieDetails?.posterPath ?? "")"))
                                    .resizable()
                             
                                    .scaledToFill()
                                    .frame(width: 80,height: 150)
                                    .clipped()
                                    .padding(.trailing, 5)
                                  
                               
                                    VStack(alignment: .leading,spacing: 12){
                                        
                                      HStack(alignment: .bottom){
                                        Text(viewModel.movieDetails?.title ?? "")
                                           
                                            .font(.system(size: 17, weight: .bold))
                                        
                                            Spacer()
                                            
                                          Image(systemName: "play.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30,alignment: .center)
                                                .onTapGesture {
                                                    navigateToTrailer = true
                                                }
                                        }
                                        
                                        Text("\(viewModel.movieDetails?.releaseDate ?? "") - \(viewModel.movieDetails?.genres?.first?.name ?? "") - \(viewModel.movieDetails?.runtime?.convertMinutesToHoursMinutes() ?? "")")
                                          
                                            .font(.system(size: 15, weight: .bold))
                                        
                                    }
                                    
                               
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, -70)
                          
                          
                            
                         
                                
                                Text(viewModel.movieDetails?.overview ?? "")
                                  
                                    .lineSpacing(2)
                                    .fontWeight(.medium)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 30)
                            
                       
                                
                         
                            Spacer()
                        }
                    }
                    .scrollIndicators(.hidden)
                
                .edgesIgnoringSafeArea(.bottom)
                .onAppear(){
                    
                    viewModel.getMovieDetails(movieId: movie.id ?? 0 )
               
                    viewModel.getTrailerDetails(movieId: movie.id ?? 0 )
                  
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
           
            .navigationBarItems(leading: BackButton())
            .navigationDestination(isPresented: $navigateToTrailer, destination: {
              TrailerView(viewModel: viewModel, movieId: movie.id ?? 0)
            })
            
        
    }
}

//#Preview {
//    MovieDetailsView()
//}




