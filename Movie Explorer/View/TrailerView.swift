//

//

import SwiftUI
import AVKit
import YouTubePlayerKit

struct TrailerView: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    @StateObject var viewModel = MovieViewModel()
    @State var player = AVPlayer()
    let movieId:Int
    
    var body: some View {
        
        ZStack{
            VStack{
               
                YouTubePlayerView(viewModel.youtubePlayer)
           
            }

            
        }

      
        .onAppear(){
            Task{
              
               try? await viewModel.youtubePlayer.play()
            }
        //  AppDelegate.orientationLock = .landscape
        }
        .onDisappear(){
            // AppDelegate.orientationLock = .portrait
        
        }
        .edgesIgnoringSafeArea(.horizontal)
        .navigationBarBackButtonHidden()
       
        .navigationBarItems(leading: BackButton())
    }
}





