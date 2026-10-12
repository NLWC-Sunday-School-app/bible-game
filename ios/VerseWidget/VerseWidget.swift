import WidgetKit
import SwiftUI

// MARK: - Verse data

/// Shared with the app, which writes the user's verse settings here.
let appGroup = "group.78RK4YBS4Q.com.nlwc.bible.game"

struct Verse {
    let reference: String
    let text: String

    static let fallback = Verse(
        reference: "Psalm 119:105",
        text: "Thy word is a lamp unto my feet, and a light unto my path."
    )
}

enum VerseStore {
    /// Loads the verses of the topics chosen in the app from memory_verses.json
    /// bundled into this extension -- the same asset the Flutter app and
    /// Android widget use -- topic by topic in file order, as the app does.
    static func loadVerses() -> [Verse] {
        guard
            let url = Bundle.main.url(forResource: "memory_verses", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let allTopics = root["topics"] as? [[String: Any]]
        else { return [.fallback] }

        let chosen = Set(UserDefaults(suiteName: appGroup)?
            .stringArray(forKey: "verseTopics") ?? [])
        let chosenTopics = allTopics.filter { chosen.contains($0["id"] as? String ?? "") }
        // Nothing chosen yet, or only topics that no longer exist: every topic.
        let topics = chosenTopics.isEmpty ? allTopics : chosenTopics

        var verses: [Verse] = []
        for topic in topics {
            guard let topicVerses = topic["verses"] as? [[String: Any]] else { continue }
            for v in topicVerses {
                if let reference = v["reference"] as? String,
                   let text = v["text"] as? String {
                    verses.append(Verse(reference: reference, text: text))
                }
            }
        }
        return verses.isEmpty ? [.fallback] : verses
    }

    /// The verse for the slot starting at `date`. Same formula as the app's
    /// lock screen verses (HourlyVerseNotification), which count the day of the
    /// year from 0 -- `ordinality` counts from 1, so it is taken down by one.
    static func verse(for date: Date, in verses: [Verse]) -> Verse {
        let calendar = Calendar.current
        let dayOfYear = (calendar.ordinality(of: .day, in: .year, for: date) ?? 1) - 1
        let hour = calendar.component(.hour, from: date)
        return verses[(dayOfYear * 24 + hour) % verses.count]
    }
}

/// How often the verse changes, as chosen in the app. Written by the app's
/// AppDelegate into the App Group both targets share.
enum VerseFrequency {
    static let supported = [1, 2, 3, 4, 6, 8, 12, 24]

    static var hours: Int {
        let stored = UserDefaults(suiteName: appGroup)?
            .integer(forKey: "verseFrequencyHours") ?? 0
        return supported.contains(stored) ? stored : 1
    }

    /// The start of the slot `date` falls in: with every 4 hours, 9:30 is in
    /// the 8:00 slot. Matches the times the lock screen verses arrive.
    static func slotStart(containing date: Date, every hours: Int) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let startOfDay = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .hour, value: hour - hour % hours, to: startOfDay) ?? date
    }

    static func label(every hours: Int) -> String {
        switch hours {
        case 1: return "VERSE OF THE HOUR"
        case 24: return "VERSE OF THE DAY"
        default: return "BIBLE VERSE"
        }
    }
}

// MARK: - Timeline

struct VerseEntry: TimelineEntry {
    let date: Date
    let verse: Verse
    var label: String = VerseFrequency.label(every: 1)
}

struct VerseTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(date: Date(), verse: .fallback)
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let verses = VerseStore.loadVerses()
        let hours = VerseFrequency.hours
        let slot = VerseFrequency.slotStart(containing: Date(), every: hours)
        completion(VerseEntry(
            date: Date(),
            verse: VerseStore.verse(for: slot, in: verses),
            label: VerseFrequency.label(every: hours)
        ))
    }

    /// One entry per slot for the next 24 hours: hourly gives 24, every 4 hours
    /// gives 6. The app reloads the timeline whenever the setting changes.
    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let verses = VerseStore.loadVerses()
        let calendar = Calendar.current
        let hours = VerseFrequency.hours
        let label = VerseFrequency.label(every: hours)
        let firstSlot = VerseFrequency.slotStart(containing: Date(), every: hours)

        var entries: [VerseEntry] = []
        for slot in 0..<(24 / hours) {
            if let entryDate = calendar.date(byAdding: .hour, value: slot * hours, to: firstSlot) {
                entries.append(VerseEntry(
                    date: entryDate,
                    verse: VerseStore.verse(for: entryDate, in: verses),
                    label: label
                ))
            }
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

// MARK: - Views

struct VerseWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: VerseEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            Text(entry.verse.reference)
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.verse.reference)
                    .font(.headline)
                Text(entry.verse.text)
                    .font(.caption2)
                    .lineLimit(3)
            }
        default:
            homeScreenView
        }
    }

    var homeScreenView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.label)
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.2)
                .foregroundColor(Color(red: 0.85, green: 0.81, blue: 0.92))
            Text("“\(entry.verse.text)”")
                .font(.system(size: family == .systemSmall ? 12 : 14))
                .foregroundColor(.white)
                .lineSpacing(2)
                .minimumScaleFactor(0.7)
            Spacer(minLength: 0)
            HStack {
                Spacer()
                Text(entry.verse.reference)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.85, blue: 0.48))
            }
        }
        .padding(2)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [
                    Color(red: 0.42, green: 0.30, blue: 0.60),
                    Color(red: 0.18, green: 0.10, blue: 0.32),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Widget definition

@main
struct VerseWidget: Widget {
    let kind: String = "VerseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VerseTimelineProvider()) { entry in
            VerseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Verse of the Hour")
        .description("A Bible verse on your home and lock screen, as often as you choose in the app.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryRectangular,
        ])
    }
}
