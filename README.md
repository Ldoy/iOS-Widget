# iOS-Widget
SwiftUI Simple Widet

![](https://user-images.githubusercontent.com/34529917/140244780-8c2fa5bb-02a9-4698-a267-de5fcc2c793e.gif)


# widget 학습내용 정리

#### 1. 위젯의 3요소
- WidgetConfiguration : 위젯을 식별하고 위젯의 content를 표시하는 역할
    ```swift
    @main
    struct MyWidget: Widget {
        let kind: String = "Widget"

        var body: some WidgetConfiguration {
            IntentConfiguration(kind: kind,
                                intent: ConfigurationIntent.self,
                                provider: Provider()) { entry in
                WidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }
    ```
    
    - IntentConfiguration : 위젯 추가화면을 사용자에게 어떻게 보여줄 것인가
        - 매게변수
            - kind : 위젯의 identifier
            - intent : 위젯 화면 직접 구성할 수 있는지 나타냄
            - provider: 타임라인 제공

        <img src = "https://i.imgur.com/j4Xfw4T.jpg" width = 200 height = 400>
            
    - StaticConfiguration : 위젯 화면을 사용

- Provider : 위젯 Rendering 할 때 필요한 `timeline`을 제공한다.
    ```swift
    struct Provider: IntentTimelineProvider {
        func placeholder(in context: Context) -> SimpleEntry {
            SimpleEntry(date: Date(), configuration: ConfigurationIntent())
        }

        func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
            let entry = SimpleEntry(date: Date(), configuration: configuration)
            completion(entry)
        }

        func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [SimpleEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, configuration: configuration)
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    ```
    - getSnapshot: 
    - getTimeline : 타임라인 항목을 제공
    
- EntryView : 위젯을 표시하는 View
    ```swift
    struct SimpleEntry: TimelineEntry {
        let date: Date
        let configuration: ConfigurationIntent
    }

    struct WidgetEntryView : View {
        var entry: Provider.Entry

        var body: some View {
            EmojiView(emoji: Emoji(icon: "🌟", name: "", description: ""))
        }
    }
    ```


#### 2. 위젯의 업데이트 흐름 

| 전체적인 흐름 | EX) 2시간마다 업데이트 | 
| -------- | -------- | 
| ![](https://i.imgur.com/NBCJGf4.png)     | ![](https://i.imgur.com/wdN273S.png)     | 



### 참고문서
https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension
https://developer.apple.com/documentation/WidgetKit/Keeping-a-Widget-Up-To-Date

https://nsios.tistory.com/156
