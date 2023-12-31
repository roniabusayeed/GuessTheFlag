//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Abu Sayeed Roni on 2023-07-31.
//

import SwiftUI

// Only for readability.
typealias ButtonState = Bool
extension ButtonState {
    mutating func change() {
        self.toggle()
    }
}

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
    
    // Keep track of rotation angle of all three button separately.
    @State private var button0RotationAngleInDegrees: Double = .zero
    @State private var button1RotationAngleInDegrees: Double = .zero
    @State private var button2RotationAngleInDegrees: Double = .zero
    
    func getRotationAngle(for index: Int) -> Double {
        if index == 0 {
            return button0RotationAngleInDegrees
        }
        if index == 1 {
            return button1RotationAngleInDegrees
        }
        if index == 2 {
            return button2RotationAngleInDegrees
        }
        return .zero
    }
    
    @State private var buttonState: ButtonState = ButtonState.random()  // it doesn't matter what we start with. The animation 'value' parameter only care about its change to trigger the animation (of any changed properties).

    @State private var button0Opacity: Double = 1.0
    @State private var button1Opacity: Double = 1.0
    @State private var button2Opacity: Double = 1.0
    
    func getOpacity(for index: Int) -> Double {
        switch index {
        case 0: return button0Opacity
        case 1: return button1Opacity
        case 2: return button2Opacity
        default: return .zero
        }
    }
    
    func changeOpacity(for index: Int) {
        
        // Fade the opacity of other two buttons to 25%
        if index == 0 {
            button1Opacity = 0.25
            button2Opacity = 0.25
        } else if index == 1 {
            button0Opacity = 0.25
            button2Opacity = 0.25
        } else if index == 2 {
            button0Opacity = 0.25
            button1Opacity = 0.25
        }
    }
    
    func resetOpacity() {
        button0Opacity = 1.0
        button1Opacity = 1.0
        button2Opacity = 1.0
    }
    
    func getScaleSize(for index: Int) -> CGSize {
        
        // Defining scale size as a function of opacity to avoid writing same kind of code written to handle the opacity.
        let opacity = getOpacity(for: index)
        if opacity >= 1.0 {
            return CGSize(width: 1.0, height: 1.0)
        }
        return CGSize(width: 1.0 - opacity, height: 1.0 - opacity)
    }
    
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
                            FlagImage(countries[index])
                        }
                        .scaleEffect(getScaleSize(for: index))
                        .rotation3DEffect(Angle(degrees: getRotationAngle(for: index)), axis: (x: 0, y: 1, z: 0))
                        .opacity(getOpacity(for: index))
                        .animation(.default, value: buttonState)
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
                Text("Your score: \(score)")
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
        
        buttonState.change()    // animation is watching this value.
        
        // Update the rotation angle of appropriate flag.
        if index == 0 {
            button0RotationAngleInDegrees += 360
        } else if index == 1 {
            button1RotationAngleInDegrees += 360
        } else if index == 2 {
            button2RotationAngleInDegrees += 360
        }
        
        // Update the opacity of the appropriate flag.
        changeOpacity(for: index)
        
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
        
        resetOpacity()
    }
    
    func resetGame() {
        score = 0
        currentNumberOfQuestion = 0
        
        resetOpacity()
    }
}

struct FlagImage: View {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .shadow(radius: 5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
