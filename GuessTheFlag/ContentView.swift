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
    @State private var score: Int = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    
    @State private var alertMessage: String = ""
    let correctFeedbackMessages = [
        "Flag-tastic! Nailed it!",
        "Whoa, flag whisperer! Amazing guess!",
        "Flawless flag expertise!",
        "Bingo! You've got the flag flair!",
        "Flag wizardry at its finest!",
        "Hoisting the flag of success! Great job!",
        "You've cracked the code of flags! Spectacular!",
        "Flag guru in the making! Impressive guess!",
        "Unfurling the flag brilliance! Well done!",
        "Flags bow to your mastery! Fantastic job!"
    ]
    
    let maximumNumberOfQuestions = 8
    @State private var currentNumberOfQuestion = 0
    @State private var showingFinalScore: Bool = false

    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.30), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.30)], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            
            VStack {
                Spacer()
                // Title
                Text("Guess The Flag")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                
                // Main interactive box.
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)    // using style instead of color because of the tranlucency effect it gives. I.e. little bit of background coming through.
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { index in
                        Button {
                            flagTapped(index)
                        } label: {
                            Image(countries[index])
                                .renderingMode(.original)
                                .shadow(radius: 5)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    // Immediate feedback alert.
                    .alert(scoreTitle, isPresented: $showingScore) {
                        Button("Continue", action: askQuestion)
                    } message: {
                        Text(alertMessage)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                
                
                
                Spacer()
                
                // Display score.
                Text("Your socre: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding(.horizontal)
        }
        
        // Final score alert.
        .alert("Final Score", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("You've scored \(score)/\(maximumNumberOfQuestions)")
        }
    }
    
    func flagTapped(_ index: Int) {
        currentNumberOfQuestion += 1
        
        if index == correctAnswer {
            scoreTitle = "Correct"
            alertMessage = correctFeedbackMessages.randomElement()!
            score += 1
        } else {
            scoreTitle = "Wrong!"
            alertMessage = "That was \(countries[index])."
        }
        showingScore = true // The alert is displayed at this point.
        
        // Check end conditions.
        if currentNumberOfQuestion == maximumNumberOfQuestions {
            showingFinalScore = true    // The final score alert is displayed at this point.
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
    }
    
    func resetGame() {
        score = 0
        currentNumberOfQuestion = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
