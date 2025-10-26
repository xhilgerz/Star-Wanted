//
//  HomeView.swift
//  Star-Wanted
//
//  Created by Alekzander Brysch on 10/26/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background parchment color
                Color(red: 0.96, green: 0.91, blue: 0.82)
                    .ignoresSafeArea()

                // Paper texture overlay
                Image("paperTexture")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.4)
                    .blendMode(.multiply)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title text
                    Text("Welcome to")
                        .font(.custom("Papyrus-Condensed", size: 60))
                        .foregroundColor(.brown)
                        .padding(.top, 30)

                    Text("Star-Wanted")
                        .font(.custom("thedeadsaloon-Regular", size: 80))
                        .foregroundColor(.black)
                        .padding(.bottom, 30)


                    // Star button as NavigationLink
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.yellow)
                            .shadow(color: .orange, radius: 15, x: 0, y: 5)
                            .padding(.top, 10)
                    }

                    Text("Tap the star to begin your bounty hunt!")
                        .font(.custom("AmericanTypewriter", size: 20))
                        .foregroundColor(.brown)
                        .italic()
                        .padding(.bottom, 30)
                }
                .padding()
            }
            Spacer()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

