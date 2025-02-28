import SwiftUI

@main
struct WealBeeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
            
            RecordView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("記録")
                }
            
            Text("ショップ画面")
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("ショップ")
                }
            
            Text("スピーカー画面")
                .tabItem {
                    Image(systemName: "speaker.wave.2.fill")
                    Text("スピーカー")
                }
            
            Text("マイページ画面")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("マイページ")
                }
        }
    }
}
