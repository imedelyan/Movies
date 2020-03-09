//
//  Movie+CoreDataClass.swift
//  Movies
//
//  Created by Igor Medelian on 3/9/20.
//  Copyright © 2020 Medelian. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    static func allMoviesRequest() -> NSFetchRequest<Movie> {
        let request = NSFetchRequest<Movie>(entityName: String(describing: Self.self))
        let sortDescriptor = NSSortDescriptor(keyPath: \Movie.popularity, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }

    static func save(from movieDTO: MovieDTO, inContext moc: NSManagedObjectContext) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(movieDTO.id)")
        let savedMovie = try? moc.fetch(request).first

        let movie = savedMovie != nil ? savedMovie : Movie(context: moc)
        movie?.updateWith(movieDTO: movieDTO)
        try? moc.save()
    }
    
    func updateWith(movieDTO: MovieDTO) {
        self.id = movieDTO.id
        self.title = movieDTO.title
        self.overview = movieDTO.overview
        self.releaseDate = movieDTO.releaseDate
        self.popularity = movieDTO.popularity
        self.voteAverage = movieDTO.voteAverage
        self.posterPath = movieDTO.posterPath
    }
}
