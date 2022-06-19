//
//  WebAPI.swift
//  Farmhouse
//
//  Created by Andrew McLane on 12/11/20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Foundation

struct WebAPI {
    static let baseURL = "https://calm-temple-08043.herokuapp.com" // e.g. https://foobar.ngrok.io (no trailing slash)
    
    static var accessToken: String?
    
    enum WebAPIError: Error {
        case identityTokenMissing
        case unableToDecodeIdentityToken
        case unableToEncodeJSONData
        case unableToDecodeJSONData
        case unauthorized
        case invalidResponse
        case httpError(statusCode: Int)
    }
    
    struct SIWAAuthRequestBody: Encodable {
        let firstName: String?
        let lastName: String?
        let appleIdentityToken: String
    }
    
    struct UserResponse: Codable {
        let accessToken: String?
        let user: UserProfile
    }
    
    static func authorizeUsingSIWA(
        identityToken: Data?,
        email: String?,
        firstName: String?,
        lastName: String?,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        // TODO: implement
        // 1
        guard let identityToken = identityToken else {
            completion(.failure(WebAPIError.identityTokenMissing))
            return
        }
        
        // 2
        guard let identityTokenString = String(data: identityToken, encoding: .utf8) else {
            completion(.failure(WebAPIError.unableToDecodeIdentityToken))
            return
        }
        
        // 3
        let body = SIWAAuthRequestBody(
            firstName: firstName,
            lastName: lastName,
            appleIdentityToken: identityTokenString
        )
        
        // 4
        guard let jsonBody = try? JSONEncoder().encode(body) else {
            completion(.failure(WebAPIError.unableToEncodeJSONData))
            return
        }
        // Create the request
        // 1
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/api/auth/siwa")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 2
        session.uploadTask(with: request, from: jsonBody) { (data, response, error) in
            // 3
            do {
                let userResponse: UserResponse =
                    try parseResponse(response, data: data, error: error)
                // 4
                accessToken = userResponse.accessToken
                
                // 5
                completion(.success(userResponse.user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    static func getProfile(
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        guard let accessToken = Self.accessToken else {
            completion(.failure(WebAPIError.unauthorized))
            return
        }
        
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/api/users/me")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            do {
                let userResponse: UserResponse = try parseResponse(response, data: data, error: error)
                completion(.success(userResponse.user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getFarms(
        completion: @escaping (Result<[PublicFarm], Error>) -> Void
    ) {
        guard let accessToken = Self.accessToken else {
            completion(.failure(WebAPIError.unauthorized))
            return
        }
        
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/farms/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            do {
                let farmsResponse: [PublicFarm] = try parseResponse(response, data: data, error: error)
                completion(.success(farmsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}


extension WebAPI {
    static func parseResponse<T: Decodable>(_ response: URLResponse?, data: Data?, error: Error?) throws -> T {
        if let error = error {
            throw error
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WebAPIError.invalidResponse
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            throw WebAPIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw WebAPIError.unableToDecodeJSONData
        }
        return decoded
    }
}
