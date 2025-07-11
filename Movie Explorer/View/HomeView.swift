//
//  HomeView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 10/07/25.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab = 0
    
    @EnvironmentObject var viewModel:MovieViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            
            
            TabView{
                
                Tab("Movies", systemImage: "movieclapper") {
                    MoviesView()
                          }
                
                          Tab("Favourite", systemImage: "star") {
                              FavoriteView()
                          }
                
                Tab("Search", systemImage: "magnifyingglass") {
                    SearchView()
                }
                             
                
//                MoviesView(viewModel: viewModel)
//                   
//                    .tabItem {
//                        if(selectedTab == 0)
//                        {
//                         
//                                Text("Movies")
//                                    .font(.system(size: 11, weight: .bold))
//                                    .foregroundColor(Color(hex: "#075985"))
//                            Image(systemName: "movieclapper")
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                            
//                        }
//                        else
//                        {
//                            Text("Movies")
//                                .font(.system(size: 11, weight: .medium))
//                                .foregroundColor(Color(hex: "#94A3B8"))
//                            Image(systemName: "movieclapper")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                        }
//                        
//                    }.tag(0)
//                
//                
//                FavoriteView(viewModel: viewModel)
//                    .tabItem {
//                        if(selectedTab == 1)
//                        {
//                            Text("Favourite")
//                                .font(.system(size: 11, weight: .bold))
//                                .foregroundColor(Color(hex: "#075985"))
//                            Image(systemName: "star")
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                        }
//                        else
//                        {
//                            Text("Favourite")
//                                .font(.system(size: 11, weight: .medium))
//                                .foregroundColor(Color(hex: "#94A3B8"))
//                            Image(systemName: "star")
//                                .resizable()
//                           .frame(width: 50, height: 50)
//                        }
//                        
//                    }.tag(1)
//                
            }
        }
        .onAppear(){
            
       viewModel.fetchDatafromRealm()
            viewModel.moviesList.removeAll()
            viewModel.page = 1
            viewModel.totalPages = 1
            viewModel.getMovieLists()
        }
    }
}

//#Preview {
//    HomeView()
//}


