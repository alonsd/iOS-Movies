//
//  MovieModel+CoreDataProperties.swift
//  
//
//  Created by Alon Shlider on 01/05/2019.
//
//

import Foundation
import CoreData


extension MovieModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieModel> {
        return NSFetchRequest<MovieModel>(entityName: "MovieModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var rating: String?
    @NSManaged public var genre: String?
    @NSManaged public var image: String?
    @NSManaged public var releaseYear: String?

}
