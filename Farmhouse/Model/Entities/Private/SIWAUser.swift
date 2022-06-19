//
//  User.swift
//  
//
//  Created by Andrew McLane on 12/11/20.
//

import Fluent
import JWT
import Vapor

final class SIWAUser: Model {
  static let schema = "siwa-users"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "email")
  var email: String

  @Field(key: "firstName")
  var firstName: String?

  @Field(key: "lastName")
  var lastName: String?

  @Field(key: "appleUserIdentifier")
  var appleUserIdentifier: String?

  init() { }

  init(
    id: UUID? = nil,
    email: String,
    firstName: String? = nil,
    lastName: String? = nil,
    appleUserIdentifier: String
  ) {
    self.id = id
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.appleUserIdentifier = appleUserIdentifier
  }
}

extension SIWAUser: Authenticatable {}

// MARK: - Public representation of a User
extension SIWAUser {
  struct Public: Content {
    let id: UUID
    let email: String
    let firstName: String?
    let lastName: String?

    init(user: SIWAUser) throws {
      self.id = try user.requireID()
      self.email = user.email
      self.firstName = user.firstName
      self.lastName = user.lastName
    }
  }

  func asPublic() throws -> Public {
    try .init(user: self)
  }
}

// MARK: - Token Creation
extension SIWAUser {
  func createAccessToken(req: Request) throws -> SIWAToken {
    let expiryDate = Date() + ProjectConfig.AccessToken.expirationTime
    return try SIWAToken(
      userID: requireID(),
      token: [UInt8].random(count: 32).base64,
      expiresAt: expiryDate
    )
  }
}

// MARK: - Helpers
extension SIWAUser {
  static func assertUniqueEmail(_ email: String, req: Request) -> EventLoopFuture<Void> {
    findByEmail(email, req: req)
      .flatMap {
        guard $0 == nil else {
          return req.eventLoop.makeFailedFuture(UserError.emailTaken)
        }
        return req.eventLoop.future()
    }
  }

  static func findByEmail(_ email: String, req: Request) -> EventLoopFuture<SIWAUser?> {
    SIWAUser.query(on: req.db)
      .filter(\.$email == email)
      .first()
  }

  static func findByAppleIdentifier(_ identifier: String, req: Request) -> EventLoopFuture<SIWAUser?> {
    SIWAUser.query(on: req.db)
      .filter(\.$appleUserIdentifier == identifier)
      .first()
  }
}
