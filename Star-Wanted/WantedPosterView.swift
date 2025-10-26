//
//  WantedPosterView.swift
//  Star-Wanted
//
//  Created by Alekzander Brysch on 10/25/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct WantedPosterView: View {
    var image: (UIImage)?
    var outlawName: String
    var reward: String

    var body: some View {
        
        
    
        ZStack {
            // Parchment texture
            Color(red: 0.96, green: 0.91, blue: 0.82)
                .ignoresSafeArea()

            Image("paperTexture")
                .resizable()
                .scaledToFill()
                .opacity(0.4)
                .blendMode(.multiply)
                .ignoresSafeArea()


            VStack(spacing: 10) {
                Text("WANTED")
                    .font(.custom("thedeadsaloon-Regular", size: 70))
                    .foregroundColor(.black)
                    .padding(.top, 1)
                
                Text("Dead or Alive ")
                    .font(.custom("thedeadsaloon-Regular", size: 45))
                    .foregroundColor(.brown)
                    .padding(.top, 1)

                if let image = image {
                    if let filtered = applyOldWestFilter(to: image) {
                            Image(uiImage: filtered)
                                
                                .resizable()
                                .border(Color.brown, width: 2)
                                .scaledToFit()
                                .frame(width: 240, height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.vertical)
                                
                        }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 200, height: 250)
                        .overlay(
                            Text("No Photo")
                                .foregroundColor(.gray)
                        )
                }

                Text(outlawName)
                    .font(.custom("thedeadsaloon-Regular", size: 40))
                    .foregroundColor(.black)

                Text(reward).bold()
                    .font(.custom("Papyrus-Condensed", size: 30))
                    .foregroundColor(.black)
                    .padding(.bottom, 1)
            }
            .padding()
            .frame(width: 350, height: 500)

            
        }
        .colorMultiply(Color(red: 0.85, green: 0.75, blue: 0.55))
            .saturation(0.7)
            .contrast(1.1)
            .overlay(
                RadialGradient(
                    gradient: Gradient(colors: [.clear, Color.black.opacity(0.35)]),
                    center: .center,
                    startRadius: 100,
                    endRadius: 400
                )
                .blendMode(.multiply)
            ).frame(width: 350, height: 600)

    }
    
    
    
    }
func applyOldWestFilter(to image: UIImage) -> UIImage? {
    let context = CIContext()
    guard let ciImage = CIImage(image: image) else { return nil }

    // Step 1: Sepia tone
    let sepia = CIFilter.sepiaTone()
    sepia.inputImage = ciImage
    sepia.intensity = 0.95

    // Step 2: Vignette (dark corners)
    let vignette = CIFilter.vignette()
    vignette.inputImage = sepia.outputImage
    vignette.intensity = 2.0
    vignette.radius = 5.0

    // Step 3: Add a slight color adjustment (desaturate a bit)
    let colorControls = CIFilter.colorControls()
    colorControls.inputImage = vignette.outputImage
    colorControls.saturation = 0.8
    colorControls.contrast = 1.2
    colorControls.brightness = -0.05

    // Step 4: Add noise texture overlay (optional)
    guard let final = colorControls.outputImage else { return nil }
    let noise = CIFilter.randomGenerator().outputImage?
        .cropped(to: final.extent)
        .applyingFilter("CIColorMatrix", parameters: [
            "inputRVector": CIVector(x: 0.05, y: 0, z: 0, w: 0),
            "inputGVector": CIVector(x: 0, y: 0.05, z: 0, w: 0),
            "inputBVector": CIVector(x: 0, y: 0, z: 0.05, w: 0)
        ])

    let composite = CIFilter.sourceOverCompositing()
    composite.inputImage = noise
    composite.backgroundImage = final

    // Render final image
    guard let output = composite.outputImage else { return nil }
    guard let cgimg = context.createCGImage(output, from: output.extent) else { return nil }

    return UIImage(cgImage: cgimg)
    
}

