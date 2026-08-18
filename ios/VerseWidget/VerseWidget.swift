import WidgetKit
import SwiftUI

// MARK: - Verse data

struct Verse {
    let reference: String
    let text: String

    static let fallback = Verse(
        reference: "Psalm 119:105",
        text: "Thy word is a lamp unto my feet, and a light unto my path."
    )
}

enum VerseStore {
    /// Loads all verses from memory_verses.json bundled into this extension.
    /// The file is the same asset the Flutter app and Android widget use.
    static func loadVerses() -> [Verse] {
        guard
            let url = Bundle.main.url(forResource: "memory_verses", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let topics = root["topics"] as? [[String: Any]]
        else { return [.fallback] }

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

    /// Deterministic verse for a given hour so all widget families agree.
    static func verse(for date: Date, in verses: [Verse]) -> Verse {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let hour = calendar.component(.hour, from: date)
        return verses[(dayOfYear * 24 + hour) % verses.count]
    }
}

// MARK: - Timeline

struct VerseEntry: TimelineEntry {
    let date: Date
    let verse: Verse
}

struct VerseTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> VerseEntry {
        VerseEntry(date: Date(), verse: .fallback)
    }

    func getSnapshot(in context: Context, completion: @escaping (VerseEntry) -> Void) {
        let verses = VerseStore.loadVerses()
        completion(VerseEntry(date: Date(), verse: VerseStore.verse(for: Date(), in: verses)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VerseEntry>) -> Void) {
        let verses = VerseStore.loadVerses()
        let calendar = Calendar.current
        let now = Date()

        // One entry at the top of each of the next 24 hours.
        let currentHour = calendar.date(
            from: calendar.dateComponents([.year, .month, .day, .hour], from: now)
        ) ?? now
        var entries: [VerseEntry] = []
        for offset in 0..<24 {
            if let entryDate = calendar.date(byAdding: .hour, value: offset, to: currentHour) {
                entries.append(
                    VerseEntry(date: entryDate, verse: VerseStore.verse(for: entryDate, in: verses))
                )
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
            Text("VERSE OF THE HOUR")
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
        .description("A new Bible verse every hour on your home and lock screen.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryInline,
            .accessoryRectangular,
        ])
    }
}
