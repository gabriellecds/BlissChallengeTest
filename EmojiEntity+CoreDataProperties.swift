//
//  EmojiEntity+CoreDataProperties.swift
//  BlissChallengeTest
//
//  Created by Gabrielle Oliveira on 06/12/24.
//
//

import Foundation
import CoreData


extension EmojiEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmojiEntity> {
        return NSFetchRequest<EmojiEntity>(entityName: "EmojiEntity")
    }

    @NSManaged public var url: String?
    @NSManaged public var id: String?

}

extension EmojiEntity : Identifiable {

}
