//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Abu Sayeed Roni on 2023-07-31.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal, .black], startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                
                ForEach(0..<3) { index in
                    Button {
                        flagTapped(index)
                    } label: {
                        Image(countries[index])
                            .renderingMode(.original)
                            .shadow(radius: 5)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }
    
    func flagTapped(_ index: Int) {
        if index == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true // The alert is displayed at this point.
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
