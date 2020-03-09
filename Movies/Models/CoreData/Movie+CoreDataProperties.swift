//
//  Movie+CoreDataProperties.swift
//  Movies
//
//  Created by Igor Medelian on 3/9/20.
//  Copyright © 2020 Medelian. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var popularity: Double
    @NSManaged public var voteAverage: Double
    @NSManaged public var posterPath: String?

}
