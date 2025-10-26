//
//  ContentView.swift
//  Star-Wanted
//
//  Created by Alekzander Brysch on 10/25/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var outlawName = ""
    @State private var reward = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // If a photo has been taken, show the wanted poster
            if let image = capturedImage {
                WantedPosterView(
                    image: image,
                    outlawName: outlawName,
                    reward: reward
                )
                .frame(width:350)
                
                
                Rectangle()
                    .fill(Color(red: 0.45, green: 0.25, blue: 0.1)) // dark wood tone
                    .frame(height: 8) // ✅ give it visible height
                    .frame(maxWidth: .infinity) // ✅ match poster width, not full screen
                    .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                    .padding(.top, -8) // ✅ optional: makes it “touch” the poster bottom


                Button(action: {
                    // Take a snapshot of the poster and save to Photos
                    let posterImage = WantedPosterView(
                        image: image,
                        outlawName: outlawName,
                        reward: reward
                    ).snapshot()

                    UIImageWriteToSavedPhotosAlbum(posterImage, nil, nil, nil)
                }) {
                    Label("Save Poster to Photos", systemImage: "square.and.arrow.down")
                        .font(.headline)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            } else {
                // Placeholder when no photo yet
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 300)
                    .overlay(
                        Text("No photo yet")
                            .foregroundColor(.gray)
                            .italic()
                    )
                    .padding()
            }

            Spacer()

            // Camera button
            Button(action: {
                Task {
                        showCamera = true
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        generateOutlaw()
                    }
            }) {
                Label("Take Wanted Photo", systemImage: "camera.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $capturedImage)
            }

            Spacer()
        }
        .background(Color(red: 0.96, green: 0.91, blue: 0.82)) // parchment background
        .edgesIgnoringSafeArea(.all)
    }

    // Generates random outlaw name and reward
    func generateOutlaw() {
        let first = ["Rusty", "Solar", "Crimson", "Cactus", "Vega", "Lunar", "Cosmic", "Iron", "Phantom"]
        let last = ["Ranger", "Drifter", "Bandit", "Cowboy", "Wrangler", "Outlaw", "Rustler", "Marauder", "Sharp Eye","Hunter"]
        outlawName = "\(first.randomElement()!) \(last.randomElement()!)"
        reward = "\(Int.random(in: 1000...10000)) CREDIT REWARD"
    }
}

// MARK: - Convert any SwiftUI View into a UIImage
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


