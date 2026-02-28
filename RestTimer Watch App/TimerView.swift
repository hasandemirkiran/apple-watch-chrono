import SwiftUI

struct TimerView: View {
    @EnvironmentObject var vm: TimerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Total elapsed — small, secondary
            HStack {
                Image(systemName: "stopwatch")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("Total")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(vm.totalElapsed.mmss)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Current rest — primary, prominent
            Text("Rest")
                .font(.caption2)
                .foregroundStyle(.green)
            Text(vm.lapElapsed.timerFormatted)
                .font(.system(.title2, design: .monospaced).weight(.semibold))
                .foregroundStyle(.green)
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            // Stats row (appears after first set)
            if !vm.laps.isEmpty {
                HStack {
                    Text("\(vm.laps.count) set\(vm.laps.count == 1 ? "" : "s")")
                    Spacer()
                    Text("avg \(vm.averageLap.mmss)")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            // Contextual buttons
            Group {
                if vm.isRunning {
                    HStack(spacing: 6) {
                        Button(action: vm.toggleStartStop) {
                            Text("Pause").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)

                        Button(action: vm.newSet) {
                            Text("New Set").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                } else if vm.totalElapsed > 0 {
                    HStack(spacing: 6) {
                        Button(role: .destructive, action: vm.reset) {
                            Text("Reset").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Button(action: vm.toggleStartStop) {
                            Text("Resume").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                } else {
                    Button(action: vm.toggleStartStop) {
                        Text("Start").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .font(.caption)
        }
        .padding(.horizontal, 2)
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerViewModel())
}
