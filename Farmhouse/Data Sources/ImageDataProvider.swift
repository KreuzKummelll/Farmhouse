//
//  ImageDataProvider.swift
//  Farmhouse
//
//  Created by Andrew McLane on 10.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import UIKit
import Combine
import FarmhouseCore

enum CustomPhoto: String {
    case no_stands = "casey-horner-kP1a91xzTvk-unsplash"
}

protocol ImageDataProvider {
  func getEndImages(for farmer: Farmer) -> AnyPublisher<[UIImage], Never>
}

private struct PixabayResponse: Codable {
  struct Image: Codable {
    let largeImageURL: String
    let user: String
  }

  let hits: [Image]
}

//Get an API Key here: https://pixabay.com/accounts/register/
class PixabayImageDataProvider: ImageDataProvider {
  let apiKey = "16225792-8fb681c7d7b72688f73a83b30"

  private func searchURL(query: String) -> URL {
    var components = URLComponents(string: "https://pixabay.com/api")!
    components.queryItems = [
      URLQueryItem(name: "key", value: apiKey),
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "image_type", value: "photo")
    ]
    return components.url!
  }

  private func imageForQuery(query: String) -> AnyPublisher<UIImage, Never> {
    URLSession.shared.dataTaskPublisher(for: searchURL(query: query))
    .map { $0.data }
    .decode(type: PixabayResponse.self, decoder: JSONDecoder())
      .tryMap { response -> URL in
        guard
          let urlString = response.hits.first?.largeImageURL,
          let url = URL(string: urlString)
          else {
            throw CustomErrors.noData
        }
          return url
    }.catch { _ in Empty<URL, URLError>() }
      .flatMap { URLSession.shared.dataTaskPublisher(for: $0) }
      .map { $0.data }
      .tryMap { imageData in
        guard let image = UIImage(data: imageData) else { throw CustomErrors.noData }
        return image
    }.catch { _ in Empty<UIImage, Never>()}
    .eraseToAnyPublisher()
  }

  func getEndImages(for farmer: Farmer) -> AnyPublisher<[UIImage], Never> {
    if farmer.standLocations.count == 0 {
      return Empty<[UIImage], Never>()
        .eraseToAnyPublisher()
    }
    if farmer.standLocations.count == 1 {
      return imageForQuery(query: farmer.standLocations[0].name)
        .map { [$0] }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    let start = imageForQuery(query: farmer.standLocations[0].name)
    let end = imageForQuery(query: farmer.standLocations.last!.name)

    return Publishers.Merge(start, end)
      .collect()
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
