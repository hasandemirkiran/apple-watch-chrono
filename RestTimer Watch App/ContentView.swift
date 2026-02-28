import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TimerViewModel()

    var body: some View {
        TabView {
            TimerView()
            LapChartView()
        }
        .tabViewStyle(.page)
        .environmentObject(vm)
    }
}

#Preview {
    ContentView()
}
