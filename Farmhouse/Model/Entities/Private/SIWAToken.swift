//
//  Token.swift
//  
//
//  Created by Andrew McLane on 12/11/20.
//

import Vapor
import Fluent

final class SIWAToken: Model {
  static let schema = "tokens"

  @ID(key: "id")
  var id: UUID?

  @Parent(key: "userID")
  var user: SIWAUser

  @Field(key: "value")
  var value: String

  @Field(key: "expiresAt")
  var expiresAt: Date?

  @Timestamp(key: "createdAt", on: .create)
  var createdAt: Date?

  init() {}

  init(
    id: UUID? = nil,
    userID: SIWAUser.IDValue,
    token: String,
    expiresAt: Date?
  ) {
    self.id = id
    self.$user.id = userID
    self.value = token
    self.expiresAt = expiresAt
  }
}

// MARK: - ModelTokenAuthenticatable
extension SIWAToken: ModelTokenAuthenticatable {
  static let valueKey = \SIWAToken.$value
  static let userKey = \SIWAToken.$user

  var isValid: Bool {
    guard let expiryDate = expiresAt else {
      return true
    }

    return expiryDate > Date()
  }
}
