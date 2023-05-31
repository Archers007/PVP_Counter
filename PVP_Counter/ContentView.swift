import SwiftUI

struct ContentView: View {
//    var player1Name: String
//    var player2Name: String
    
    @State private var player1Name = "PLAYER1"
    @State private var player2Name = "PLAYER2"
    @State private var player1Score = 6
    @State private var player2Score = 9
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                HStack {
                    Text("\(player1Name) :")
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
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
