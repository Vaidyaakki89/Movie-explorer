//
//  MovieResultModel.swift
//  Movie Explorer
//
//  Created by AKSHAY VAIDYA on 11/07/25.
//

import Foundation
import RealmSwift


class MovieResult: Object {
    @Persisted var adult: Bool
    @Persisted var backdropPath: String
    @Persisted var genreIDS: List<Int>
    @Persisted var id: Int
    @Persisted var originalLanguage: String
    @Persisted var originalTitle: String
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var posterPath : String
    @Persisted var releaseDate : String
    @Persisted var title : String
    @Persisted var video: Bool
    @Persisted var voteAverage: Double
    @Persisted var voteCount: Int
    
    var genreList = List<Int>()
}




extension Array<Int>{
    
    func getList()-> List<Int>{
        
        var genreList = List<Int>()
        for id in self {
       
            genreList.append(id)
        }
        return genreList
    }
}
