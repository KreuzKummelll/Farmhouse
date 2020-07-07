//
//  MapDataProvider.swift
//  Farmhouse
//
//  Created by Andrew McLane on 07.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Foundation
import Combine
import MapKit
import CoreLocation
import FarmhouseCore


protocol MapDataProvider {
    func getLocation(for address: String) -> AnyPublisher<CLPlacemark, Error>
    func directions(for stands: [StandLocation]) -> AnyPublisher<[MKRoute], Error>
    func totalDistance(for farm: [StandLocation]) -> AnyPublisher<Double, Never>
}

enum CustomErrors: String, Error {
  case unknown
  case noData
}

class RealMapDataProvider: MapDataProvider {
  let geocoder = CLGeocoder()

  func getLocation(for address:String) -> AnyPublisher<CLPlacemark, Error> {
    let subject = PassthroughSubject< CLPlacemark, Error>()

    geocoder.geocodeAddressString(address) { placemarks, error in
      if let placemark = placemarks?.first {
        subject.send(placemark)
        subject.send(completion: .finished)
      } else if let error = error {
        subject.send(completion: .failure(error))
      } else {
        subject.send(completion: .failure(CustomErrors.unknown))
      }
    }

    return subject
      .eraseToAnyPublisher()
  }

  func directions(for waypoints:[StandLocation]) -> AnyPublisher<[MKRoute], Error> {
    guard waypoints.count > 1 else {
      return Empty<[MKRoute], Error>().eraseToAnyPublisher()
    }

    var routePublishers: [AnyPublisher<[MKRoute], Error>] = []

    (0 ..< waypoints.count - 1).forEach { index in
      let start = waypoints[index]
      let end = waypoints[index + 1]

      let request = MKDirections.Request()
      request.transportType = .automobile
//      request.source = start.mapItem
//      request.destination = end.mapItem

      let directions = MKDirections(request: request)
      routePublishers.append(directions.calculate())
    }

    let allPublisher = Publishers.Sequence<[AnyPublisher<[MKRoute], Error>], Error>(sequence: routePublishers)
    return allPublisher.flatMap { $0 }
      .collect()
      .map { $0.compactMap { $0.first }} // get just the first route and make a list
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
    }

  func totalDistance(for trip: [StandLocation]) -> AnyPublisher<Double, Never> {
    return directions(for: trip)
      .replaceError(with: [])
      .map { routes in
        routes.map { route in
          route.distance
        }.reduce(0, +)
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

extension MKDirections {
  func calculate() -> AnyPublisher<[MKRoute], Error> {
    let subject = PassthroughSubject<[MKRoute], Error>()
    calculate { response, error in
      if let routes = response?.routes {
        subject.send(routes)
        subject.send(completion: .finished)
      } else if let error = error {
        subject.send(completion: .failure(error))
      } else {
        subject.send(completion: .finished)
      }
    }
    return subject.eraseToAnyPublisher()
  }
}

extension CLLocationCoordinate2D {
  static var timesSquare: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: 40.757, longitude: -73.986)}
}

extension CLLocationCoordinate2D {
    public init(from decoder: Decoder) throws {
        let representation =
            try decoder.singleValueContainer().decode([String:CLLocationDegrees].self)
        self.init(latitude: representation["latitude"] ?? 0, longitude:  representation["longitude"] ?? 0)
    }
  
    public func encode(to encoder: Encoder) throws {
        let representation = ["latitude": self.latitude, "longitude": self.longitude]
        try representation.encode(to: encoder)
    }
}
