//
//  ContentView.swift
//  Tagly
//
//  Created by Darien Sandifer on 1/1/23.
//

import SwiftUI
import Haptica
import AVKit

enum Mode {
    case ahead, right
}

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var mode = Mode.ahead
    let synthesizer = AVSpeechSynthesizer()
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    Circle()
                        .fill(mode == .ahead ? Color.pink : .green)
                        .frame(width: 16, height: 16)
                        .offset(y: mode == .ahead ? -4 : -8)
                        .scaleEffect(mode == .ahead ? 2 : 1)
                    
                    Spacer()
                }
                
                Circle()
                    .trim(from: 0.025, to: mode == .ahead ? 0.0 : 0.225)
                    .rotation(Angle(degrees: -90))
                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .opacity(mode == .ahead ? 0 : 1)
            }
            .frame(width: 312, height: 312)
            
            ZStack {
                
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: 16, height: 16)
                        .offset(x: 8)
                        .opacity(mode == .ahead ? 0 : 1)
                }
            }
            .frame(width: 312, height: 312)
            .rotationEffect(Angle(degrees: mode == .ahead ? -90 : 0))
            
            Image(systemName: "arrow.up")
                .font(.system(size: 192, weight: .bold))
                .rotationEffect(Angle(degrees: mode == .ahead ? 0 : 90))
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("FINDING")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Darien's Keys")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("20")
                        Text("ft")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        if mode == .right {
                            Text("to your")
                            Text("right")
                                .foregroundColor(.secondary)
                        } else {
                            Text("ahead")
                        }
                        
                        Spacer()
                    }
                }
                .font(.system(size: 48, design: .rounded))
                .padding(.bottom)
                
                HStack {
                    Button(action: { }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(.gray)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: { }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(.gray)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onReceive(timer) { time in
            toggleMode()
        }
        .background((mode == .ahead ? Color.green : Color.gray).edgesIgnoringSafeArea(.all))
    }
    
    func toggleMode() {
        if mode == .ahead {
            withAnimation(.easeInOut(duration: 1)) {
                mode = .right
                speak()
            }
        } else {
            withAnimation(.easeInOut(duration: 1)) {
                mode = .ahead
                Haptic.impact(.heavy).generate()
                playSound()
            }
        }
    }
    
    func playSound() -> Void {
        // Load a local sound file
        guard let soundFileURL = Bundle.main.path(
            forResource: "sound_effect",
            ofType: "mp3"
        )else {
            return
        }

        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFileURL))
        self.audioPlayer.play()
    }
    
    func speak() -> Void {
        if(mode == .ahead){
            let utterance = AVSpeechUtterance(string: "20 feet ahead")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
            
        }else if(mode == .right){
            let utterance = AVSpeechUtterance(string: "20 feet to your right")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
