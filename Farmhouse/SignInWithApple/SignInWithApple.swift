//
//  SignInWithApple.swift
//  Farmhouse
//
//  Created by Andrew McLane on 12/11/20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//


import SwiftUI
import AuthenticationServices

final class SignInWithApple: UIViewRepresentable {
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    return ASAuthorizationAppleIDButton()
  }

  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
  }
}
