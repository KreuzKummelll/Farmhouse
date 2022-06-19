//
//  UserProfile.swift
//  Farmhouse
//
//  Created by Andrew McLane on 12/11/20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//


import Foundation

struct UserProfile: Codable {
  let id: UUID
  let email: String
  let firstName: String?
  let lastName: String?
}
