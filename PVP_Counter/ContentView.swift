import SwiftUI
import UIKit

enum Page {
    case home
    case plus
    case open
    case settings
}

struct ContentView: View {
    @State private var player1Name = "Kieran"
    @State private var player2Name = "Adam"
    @State private var player1Score = 6
    @State private var player2Score = 9
    @State private var selectedGame = 0
    @State private var showConfirmationAlert = false;
    
    @State private var date = ""
    @State private var time = ""
    @State private var uid = "edtrcfyvgbuhjgvcfrd"
    
    let games = ["PVZ Heros", "MTG", "Random Bet"]
    let endpoint = "https://ntek.kieranbendell.dev"
    
    @State private var currentPage: Page = .home
    @State private var player1Input = ""
    @State private var player2Input = ""
    @State private var uidInput = ""
    @State private var openedGames: [String] = []
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Text("\(player1Name)")
                        .foregroundColor(.red)
                        .font(.custom("Mothercode", size: 34))
                        .padding(.leading)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("\(player1Score)")
                        .foregroundColor(.red)
                        .font(.custom("Mothercode", size: 34))
                    Text("VS")
                        .foregroundColor(.white)
                        .font(.custom("Mothercode", size: 34))
                    Text("\(player2Score)")
                        .foregroundColor(.blue)
                        .font(.custom("Mothercode", size: 34))
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("\(player2Name)")
                        .foregroundColor(.blue)
                        .font(.custom("Mothercode", size: 34))
                        .padding(.trailing)
                }
                
                Spacer()
                
                VStack {
                    Picker(selection: $selectedGame, label: Text("Game")) {
                        ForEach(games.indices, id: \.self) { index in
                            Text(games[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    HStack{
                        Button(action: {
                            sendPostRequestToEndpointWin(winner:"\(player1Name)",UID:uid,game:games[selectedGame])
                        }) {
                            Text("\(player1Name) Wins")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            sendPostRequestToEndpointWin(winner:"\(player2Name)",UID:uid,game:games[selectedGame])
                        }) {
                            Text("\(player2Name) Wins")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
            }
            
            if currentPage != .home {
                Color.black
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Spacer()
                
                switch currentPage {
                case .home:
                    
                    Text("")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                case .plus:
                    VStack {
                        TextField("Player 1", text: $player1Input)
                            .font(.custom("Mothercode", size: 20))
                            .padding()
                            .background(Color.red)
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            
                        
                        TextField("Player 2", text: $player2Input)
                            .font(.custom("Mothercode", size: 20))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                        
                        Button(action: {
                            sendPostRequestToEndpointNew(player1: player1Input, player2: player2Input)
                        }) {
                            Text("Submit")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                case .open:
                    VStack {
                        TextField("UID", text: $uidInput)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        Button(action: {
                            sendPostRequestToEndpointOpen(UID: uidInput)
                        }) {
                            Text("Open")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        ForEach(openedGames, id: \.self) { gameUID in
                            Button(action: {
                                sendPostRequestToEndpointOpen(UID: gameUID)
                            }) {
                                Text(gameUID)
                                    .font(.custom("Mothercode", size: 20))
                                    .padding()
                                    .background(Color.yellow)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                case .settings:
                    VStack {
                        Button(action: {
                            // Open webpage action
                        }) {
                            Text("Open WebPage")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            showConfirmationAlert = true
                        }) {
                            Text("Delete PVP")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            copyUIDToClipboard()
                        }) {
                            Text("UID: \(uid)")
                                .font(.custom("Mothercode", size: 20))
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .alert(isPresented: $showConfirmationAlert) {
                        Alert(
                            title: Text("Delete PVP"),
                            message: Text("Are you sure you want to delete this PVP?"),
                            primaryButton: .cancel(),
                            secondaryButton: .destructive(Text("Delete"), action: {
                                sendPostRequestToEndpointDelete(UID: uid)
                            })
                        )
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        sendPostRequestToEndpointScore(UID:uid)
                        currentPage = .home
                    }) {
                        Image(systemName: "house.fill")
                            .foregroundColor(currentPage == .home ? .blue : .white)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        currentPage = .plus
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(currentPage == .plus ? .red : .white)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        currentPage = .open
                    }) {
                        Image(systemName: "folder.fill")
                            .foregroundColor(currentPage == .open ? .blue : .white)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        currentPage = .settings
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(currentPage == .settings ? .red : .white)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .onAppear {
            sendPostRequestToEndpointScore(UID: self.uid)
        }
    }
    
    func sendPostRequestToEndpointWin(winner: String, UID: String, game: String) {
        let url = URL(string: "\(endpoint)/win")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body as a dictionary
        let requestBody = ["winner": winner, "UID": UID, "gamePlayed": game]
        
        // Convert the request body to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        print(jsonData)
        request.httpBody = jsonData
        
        // Set the appropriate headers for JSON content
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(responseJSON)")
                } else {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "")")
                }
            }
            
            // Assuming you have a function named "updateScores" to update player1Score and player2Score
            DispatchQueue.main.async {
                sendPostRequestToEndpointScore(UID: UID)
            }
        }.resume()
    }

    
    func sendPostRequestToEndpointScore(UID: String) {
        let url = URL(string: "\(endpoint)/score")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "UID": UID
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response or error
                
                // Assuming the response contains player1Score and player2Score as JSON data
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let player1Score = json?["player1Score"] as? Int,
                           let player2Score = json?["player2Score"] as? Int {
                            DispatchQueue.main.async {
                                self.player1Score = player1Score
                                self.player2Score = player2Score
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                
            }.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }

    func sendPostRequestToEndpointNew(player1: String, player2: String) {
        let url = URL(string: "\(endpoint)/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body as a dictionary
        let bodyData: [String: Any] = [
            "Player1": player1,
            "Player2": player2
        ]
        
        // Convert the bodyData dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            // Assuming the response contains the UID
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let uidNEW = json?["UID"] as? String {
                        DispatchQueue.main.async {
                            self.player1Input = ""
                            self.player2Input = ""
                            self.sendPostRequestToEndpointOpen(UID: uidNEW)
                        }
                        print(uidNEW)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }


    func sendPostRequestToEndpointDelete(UID: String) {
        let url = URL(string: "\(endpoint)/delete")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body as a dictionary
        let bodyData: [String: Any] = [
            "UID":UID
        ]
        
        // Convert the bodyData dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            // Assuming the response contains the UID
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }

    func sendPostRequestToEndpointOpen(UID: String) {
        let url = URL(string: "\(endpoint)/open")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the request body as a dictionary
        let bodyData: [String: Any] = [
            "UID":UID
        ]
        
        // Convert the bodyData dictionary to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.player1Input = ""
        self.player2Input = ""
        self.uidInput = ""
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            // Assuming the response contains the UID
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let p1 = json?["Player1"] as? String {
                        self.player1Name = p1
                    }
                    if let p2 = json?["Player2"] as? String {
                        self.player2Name = p2
                    }
                    self.uid = UID
                    if !self.openedGames.contains(UID) {
                        self.openedGames.append(UID)
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }

    func sendPostRequestToEndpointHistory(UID: String) {
        let url = URL(string: "\(endpoint)/history")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "UID=\(UID)".data(using: .utf8)
        request.httpBody = bodyData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error
            
            // Assuming the response contains the web page URL
            if let data = data,
               let webpageURLString = String(data: data, encoding: .utf8),
               let webpageURL = URL(string: webpageURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(webpageURL)
                }
            }
        }.resume()
    }

    
    func copyUIDToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = uid
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
