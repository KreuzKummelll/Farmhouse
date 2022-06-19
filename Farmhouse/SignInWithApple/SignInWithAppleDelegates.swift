//
//  SignInWithAppleDelegates.swift
//  Farmhouse
//
//  Created by Andrew McLane on 12/11/20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import UIKit
import AuthenticationServices
import Contacts

class SignInWithAppleDelegates: NSObject {
  private let signInSucceeded: (Result<UserProfile, Error>) -> Void
  private weak var window: UIWindow!

  init(window: UIWindow?, onSignedIn: @escaping (Result<UserProfile, Error>) -> Void) {
    self.window = window
    self.signInSucceeded = onSignedIn
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  private func authorizeWithSIWA(credential: ASAuthorizationAppleIDCredential) {
    WebAPI.authorizeUsingSIWA(
      identityToken: credential.identityToken,
      email: credential.email,
      firstName: credential.fullName?.givenName,
      lastName: credential.fullName?.familyName,
      completion: { result in
        switch result {
        case .success: self.getProfile()
        case .failure(let error): self.signInSucceeded(.failure(error))
        }
      })
  }

  private func getProfile() {
    WebAPI.getProfile { result in
      switch result {
      case .success(let profile): self.signInSucceeded(.success(profile))
      case .failure(let error): self.signInSucceeded(.failure(error))
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      authorizeWithSIWA(credential: appleIdCredential)
    default:
      break
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.signInSucceeded(.failure(error))
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}
