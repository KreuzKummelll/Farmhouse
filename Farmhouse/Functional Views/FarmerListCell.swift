//
//  TripListCell.swift
//  Farmhouse
//
//  Created by Andrew McLane on 10.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import SwiftUI
import Combine
import FarmhouseCore

struct FarmerListCell: View {
    let imageProvider: ImageDataProvider = PixabayImageDataProvider()
    @ObservedObject var farmer: Farmer
    
    
    @State private var images: [UIImage] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                SplitImage(images: self.images)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                BlurView()
                    .frame(width: geometry.size.width, height: 42)
                Text(self.farmer.name)
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
            }
        .cornerRadius(12)
        }.onAppear() {
            self.cancellable = self.imageProvider.getEndImages(for: self.farmer).assign(to: \.images, on: self)
        }
    }
}

#if DEBUG
struct FarmerListCell_Preview: PreviewProvider {
    static var previews: some View {
        let model = DataModel.sample
        let farmer = model.farmers[0]
        return FarmerListCell(farmer: farmer)
            .frame(height: 160)
        .environmentObject(model)
    }
}
#endif

struct BlurView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
    }
}
