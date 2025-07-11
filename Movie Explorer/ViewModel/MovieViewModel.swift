//
//  MovieViewModel.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 10/07/25.
//


import RealmSwift
import Foundation
import SwiftUI
import AVKit
import Alamofire
import YouTubePlayerKit


class MovieViewModel:ObservableObject{
    
    var totalPages = 1
    var page : Int = 1
    @Published var searchTxt = ""
    @Published var isUpdated :Bool = false
    @Published var moviesList = [Result]()
    @Published var searchList = [Result]()
    @Published var favouriteList = [Result]()
    @Published var favouriteMovieDict = [Int:Bool]()
    @Published var movieDetails:MovieDetailsModel?
 
    var notificationToken: NotificationToken?
    @Published var youtubePlayer = YouTubePlayer()
    @Published var notificationcenter = UNUserNotificationCenter.current()
    
    func getMovieLists(){
        
        
        guard var components = URLComponents(string:"\(APIConstants.basedURL)movie/now_playing") else {return}
           
           // Query parameters
           components.queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.apiKey),
               URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "\(page)")
           ]
        guard let url = components.url else {
              print("Failed to construct URL from components")
              return
          }

          // Make the network request using Alamofire
        AF.request(url).responseDecodable(of: MoviesModel.self) { [weak self] response in
            switch response.result {
               case .success(let movieResponse):
               // print(movieResponse.results)
            
                DispatchQueue.main.async {
                    self?.totalPages = movieResponse.totalPages ?? 0
                   
                  
                    self?.moviesList.append(contentsOf:movieResponse.results ?? [])
           
                    
                }

               case .failure(let error):
                   print("Decoding failed with error: \(error.localizedDescription)")
               }
           }


    }
    
    func createSearchList(){
        
        if !searchTxt.isEmpty{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
                searchList = moviesList.filter({$0.title?.lowercased().starts(with: searchTxt.lowercased()) == true})
            }
        }
        else{
            
            searchList.removeAll()
        }
    }
    
    func addToDatabase(movie: Result){
        
      let realm = try! Realm()

        try! realm.write {
            let movieResult = MovieResult()
            movieResult.adult = movie.adult ?? false
            movieResult.overview = movie.overview ?? ""
            movieResult.backdropPath = movie.backdropPath ?? ""
            movieResult.id = movie.id ?? 0
            movieResult.originalLanguage = movie.originalLanguage ?? ""
            movieResult.originalTitle = movie.originalTitle ?? ""
            movieResult.popularity = movie.popularity ?? 0.0
            movieResult.posterPath = movie.posterPath ?? ""
            movieResult.releaseDate = movie.releaseDate ?? ""
            movieResult.title = movie.title ?? ""
            movieResult.video = movie.video ?? false
            movieResult.voteAverage = movie.voteAverage ?? 0.0
            movieResult.voteCount = movie.voteCount ?? 0
            
         
            if let genreIDs = movie.genreIDS {
                var genreList = genreIDs.getList()

                movieResult.genreIDS = genreList
            }
            
            realm.add(movieResult)
        
        }
   
    }
    
    func fetchDatafromRealm(){
     
        
        do {
            let realm = try Realm()
            let results = realm.objects(MovieResult.self)
            
            notificationToken = results.observe {[weak self] changes in
                switch changes {
                case .initial(let initialResults):
                    print("Initial results count: \(initialResults.count)")
                    self?.initFavouriteList(movieslist: Array(initialResults))
                case .update(let updatedResults, let deletions, let insertions, let modifications):
                    print("Updated results")
                  //  print("Inserted: \(insertions), Deleted: \(deletions), Modified: \(modifications)")
                    if let updatedResult = updatedResults.last, insertions.count != 0{
                     
                        self?.addDataToFavorite(updatedResult: updatedResult)
                    }
                case .error(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            print("Failed to observe Realm: \(error)")
        }
        
    }
    
    
    func initFavouriteList(movieslist:[MovieResult]){
        favouriteList.removeAll()
       // print(movieslist)
        
        for movie in movieslist{
            let genreIds = Array(movie.genreIDS.map{$0})
            let model = Result(adult: movie.adult, backdropPath: movie.backdropPath, genreIDS:genreIds , id: movie.id, originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle, overview: movie.overview, popularity: movie.popularity, posterPath: movie.posterPath, releaseDate: movie.releaseDate, title: movie.title, video: movie.video, voteAverage: movie.voteAverage, voteCount: movie.voteCount)
          //  print(model)
            favouriteList.append(model)
            favouriteMovieDict[movie.id] = true
        }
        
    }
    
    
    func addDataToFavorite(updatedResult:MovieResult){
        
        let genreIds = Array(updatedResult.genreIDS.map{$0})
        
        let model = Result(adult: updatedResult.adult, backdropPath: updatedResult.backdropPath, genreIDS:genreIds , id: updatedResult.id, originalLanguage: updatedResult.originalLanguage, originalTitle: updatedResult.originalTitle, overview: updatedResult.overview, popularity: updatedResult.popularity, posterPath: updatedResult.posterPath, releaseDate: updatedResult.releaseDate, title: updatedResult.title, video: updatedResult.video, voteAverage: updatedResult.voteAverage, voteCount: updatedResult.voteCount)
      //  print(model)
        favouriteList.append(model)
      
    }
    
    func removeDataFromFavourite(movie1:Result){
     
        do{
            let realm = try Realm()
            
            try realm.write{
                
                realm.delete(realm.objects(MovieResult.self).filter({$0.id == movie1.id}))
                
             
            }

        
        }
        catch{
            
            print("Failed to observe Realm: \(error)")
        }
        
       
        
        favouriteList.removeAll(where: {movie in
                movie == movie1
            })
       
        
    }
    
    
    
    func getMovieDetails(movieId:Int){
        movieDetails = nil
        var components = URLComponents(string: "\(APIConstants.basedURL)movie/\(movieId)")!
           
         
           components.queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.apiKey),
            URLQueryItem(name: "language", value: "en-US")
           ]
        
        guard let url = components.url else {
              print("Failed to construct URL from components")
              return
          }
           
        AF.request(url).responseDecodable(of: MovieDetailsModel.self) { [weak self] response in
            switch response.result {
               case .success(let movieResponse):
               // print(movieResponse.results)
            
                DispatchQueue.main.async {
                    self?.movieDetails = movieResponse
           
                    
                }

               case .failure(let error):
                   print("Decoding failed with error: \(error.localizedDescription)")
               }
           }

        
      
        
    }
    
    func loadMoreContent(obj:Result){
        if (page) <= totalPages {
            page += 1
            getMovieLists()
        
        }
        else
        {
           
        
        }
    }

    
    

  
    func getTrailerDetails(movieId:Int){
        
        var components = URLComponents(string: "\(APIConstants.basedURL)movie/\(movieId)/videos")!
           
           // Query parameters
           components.queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.apiKey)
            
           ]
        
        guard let url = components.url else {
              print("Failed to construct URL from components")
              return
          }
           
        AF.request(url).responseDecodable(of: TrailerModel.self) { [weak self] response in
            switch response.result {
               case .success(let model):
                
                DispatchQueue.main.async {
                    let keys = model.results?.map({$0.key ?? ""}) ?? []
                  //  self.trailers = model.results ?? []
                    let source = YouTubePlayer.Source.videos(ids: keys)
                    self?.youtubePlayer = YouTubePlayer(source: source)
                }
              //  print(model)

               case .failure(let error):
                   print("Decoding failed with error: \(error.localizedDescription)")
               }
           }
  
        
    }
    
//
    
    func convertDateFormat(dateString: String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat  // Input format
       // dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct parsing

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = toFormat // Output format
            return dateFormatter.string(from: date)
        }
        return "Invalid date"
    }
    
    
    func triggerNotification(message:String, title:String)
    {
        
      
            
            let content = UNMutableNotificationContent()
            
        content.body = message
        content.title = title
       
        content.sound = .default
     // content.badge = 1
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

        notificationcenter.add(request) { error in
            if let error = error {
                print("Notification failed: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
}



