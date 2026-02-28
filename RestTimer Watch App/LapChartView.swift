import SwiftUI
import Charts

struct LapChartView: View {
    @EnvironmentObject var vm: TimerViewModel

    var body: some View {
        if vm.laps.isEmpty {
            emptyState
        } else {
            chartContent
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 6) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
            Text("Tap 'New Set' to\nrecord rest times")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Chart

    private var chartContent: some View {
        VStack(alignment: .leading, spacing: 3) {
            // Total time always visible at top
            HStack {
                Text("Total")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(vm.totalElapsed.mmss)
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            Text("Rest Durations")
                .font(.caption2)
                .foregroundStyle(.primary)

            Chart {
                ForEach(Array(vm.laps.enumerated()), id: \.offset) { i, lap in
                    LineMark(
                        x: .value("Set", i + 1),
                        y: .value("Seconds", lap)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Set", i + 1),
                        y: .value("Seconds", lap)
                    )
                    .foregroundStyle(.green)
                    .symbolSize(25)
                }

                // Average line
                RuleMark(y: .value("Average", vm.averageLap))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 2]))
                    .foregroundStyle(.orange)
                    .annotation(position: .top, alignment: .trailing) {
                        Text("avg \(vm.averageLap.mmss)")
                            .font(.system(size: 8))
                            .foregroundStyle(.orange)
                            .padding(.trailing, 2)
                    }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: min(vm.laps.count, 5))) { value in
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("\(v)")
                                .font(.system(size: 8))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text(v.mmss)
                                .font(.system(size: 8))
                        }
                    }
                }
            }
            .frame(height: 85)

            // Bottom stats
            HStack {
                Text("\(vm.laps.count) set\(vm.laps.count == 1 ? "" : "s")")
                Spacer()
                if let last = vm.laps.last {
                    Text("last \(last.mmss)")
                }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 2)
    }
}

#Preview {
    let vm = TimerViewModel()
    // Inject some sample laps for preview
    return LapChartView()
        .environmentObject(vm)
}
