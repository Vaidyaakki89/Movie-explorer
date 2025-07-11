//
//  ContentView.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 11/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationStack{
            
            HomeView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView()
}
