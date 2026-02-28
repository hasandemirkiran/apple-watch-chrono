import Foundation

class TimerViewModel: ObservableObject {
    @Published var totalElapsed: TimeInterval = 0
    @Published var lapElapsed: TimeInterval = 0
    @Published var laps: [TimeInterval] = []
    @Published var isRunning = false

    private var totalBase: TimeInterval = 0
    private var lapBase: TimeInterval = 0
    private var totalStart: Date?
    private var lapStart: Date?
    private var timer: Timer?

    var averageLap: TimeInterval {
        guard !laps.isEmpty else { return 0 }
        return laps.reduce(0, +) / Double(laps.count)
    }

    func toggleStartStop() {
        isRunning ? pause() : resume()
    }

    func newSet() {
        guard isRunning else { return }
        laps.append(lapElapsed)
        lapBase = 0
        lapElapsed = 0
        lapStart = Date()
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        totalElapsed = 0
        lapElapsed = 0
        totalBase = 0
        lapBase = 0
        laps = []
        totalStart = nil
        lapStart = nil
    }

    private func resume() {
        let now = Date()
        totalStart = now
        lapStart = now
        isRunning = true
        let t = Timer(timeInterval: 1.0 / 20.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func pause() {
        timer?.invalidate()
        timer = nil
        totalBase = totalElapsed
        lapBase = lapElapsed
        totalStart = nil
        lapStart = nil
        isRunning = false
    }

    private func tick() {
        let now = Date()
        if let ts = totalStart {
            totalElapsed = totalBase + now.timeIntervalSince(ts)
        }
        if let ls = lapStart {
            lapElapsed = lapBase + now.timeIntervalSince(ls)
        }
    }
}

extension TimeInterval {
    /// MM:SS.tenths — used for the live rest display
    var timerFormatted: String {
        let t = max(0, self)
        let m = Int(t) / 60
        let s = Int(t) % 60
        let tenths = Int(t.truncatingRemainder(dividingBy: 1) * 10)
        return String(format: "%d:%02d.%d", m, s, tenths)
    }

    /// H:MM:SS or MM:SS — used for total time and chart labels
    var mmss: String {
        let t = max(0, self)
        let h = Int(t) / 3600
        let m = (Int(t) % 3600) / 60
        let s = Int(t) % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%d:%02d", m, s)
    }
}
