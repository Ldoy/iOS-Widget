# iOS-Widget
SwiftUI Simple Widet
| 개인적인연습 | 활동학습위젯 |
| -------- | -------- |
| ![](https://user-images.githubusercontent.com/34529917/140244780-8c2fa5bb-02a9-4698-a267-de5fcc2c793e.gif)     | Text ![](https://i.imgur.com/laI8FFg.gif)




# SwiftUI- widget

## 위젯의 3요소
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
### 위젯의 구성요소 자세히 보기  
- `EntryView`: Widget 의 컨텐츠를 보여주는 뷰.
- `Provider` 의 각 메서드
    - Provider     
        > Provider: An object that conforms to `[TimelineProvider](https://developer.apple.com/documentation/widgetkit/timelineprovider)` and produces a timeline telling WidgetKit when to render the widget. A timeline contains a custom `[TimelineEntry](https://developer.apple.com/documentation/widgetkit/timelineentry)` type that you define. Timeline entries identify the date when you want WidgetKit to update the widget’s content. Include properties your widget’s view needs to render in the custom type.
 
     - getSnapshot - `WidgetKit`은 이런 위젯을 추가할 때와 같이 일시적인 상황에서 위젯을 표시하기 위해서 Snapshot 요청
        - WidgetKit calls `getSnapshot(in:completion:)` when the widget appears in transient situations.
        - placeholder - A placeholder view is a generic visual representation with no specific content.
    - `getTimeline` 메서드
        - 나중에 위젯을 업데이트하거나 현재 시간을 알려주는 타임라인앤트리 배열을 제공. 나중에 OS가 이 타임라인에 맞춰서 뷰를 업데이트할 수 있도록 역할을 감당함

            > Provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
                     
- Timeline의 policy
    - Definition
        ```swift
          /// A type that indicates the earliest date WidgetKit requests a new timeline
                    /// from the widget's provider.
        @available(iOS 14.0, macOS 11, *)
        @available(tvOS, unavailable)
        @available(watchOS, unavailable)
        public struct TimelineReloadPolicy : Equatable {
                    
                        /// A policy that specifies that WidgetKit requests a new timeline after
                        /// the last date in a timeline passes.
                        public static let atEnd: TimelineReloadPolicy
                    
                        /// A policy that specifies that the app prompts WidgetKit when a new
                        /// timeline is available.
                        public static let never: TimelineReloadPolicy
                    
                        /// A policy that specifies a future date for WidgetKit to request a new
                        /// timeline.
                        public static func after(_ date: Date) -> TimelineReloadPolicy
                    
                        /// Returns a Boolean value indicating whether two values are equal.
                        ///
                        /// Equality is the inverse of inequality. For any values `a` and `b`,
                        /// `a == b` implies that `a != b` is `false`.
                        ///
                        /// - Parameters:
                        ///   - lhs: A value to compare.
                        ///   - rhs: Another value to compare.
                        public static func == (a: TimelineReloadPolicy, b: TimelineReloadPolicy) -> Bool
                    }   
        ```
                    
        - policy는 3개의 프로퍼티를 가지고 있다. `atEnd` , `after(date:)` , `never`
            - atEnd - 타임라인의 마지막 날짜가 지난 후 WidgetKit이 새 타임라인을 요청하도록 지정하는 policy입니다
            - after(date:) - 타임라인의 마지막 날짜가 지난 후 WidgetKit이 새 타임라인을 요청하도록 지정하는 policy입니다
            - never - WidgetKit은 앱이 WidgetCenter를 사용하여 WidgetKit에 새 타임라인을 요청하도록 지시 할 때 까지 다른 timeline을 요청하지 않는 친구입니다
            - 위젯은 언제 업데이트되나?
                - 타임라인 엔트리에 기반하여 시스템에 의해 업데이트 진행됨



### 위젯의 업데이트 흐름 

1. Configuration으로 위젯 설정
2. TimelineProvider에서 디스플레이 업데이트 시기를 설정(timeline)
3. 위젯이 처음 렌더할때 timeprovider 에서 timeline을 받음
4. 위젯킷이 지금 다시 그려야되는 시간인지 계속 물어봄 그리고 시간이 되면 그때에 맞는 view 내보냄

| 전체적인 흐름 | EX) 2시간마다 업데이트 | 
| -------- | -------- | 
| ![](https://i.imgur.com/NBCJGf4.png)     | ![](https://i.imgur.com/wdN273S.png)     | 


#### Widget 활동학습 정리 
1. 앱 익스텐션은 앱이 아니다 
    1. 따라서 라이프 사이클이 다르다. 
        ![](https://i.imgur.com/naL3yc5.png)

        
    2. 호스트앱에 의해 만들어진다. 
    3. 
2. 컨테이닝 앱, 앱 익스텐션, 호스트앱이란?
    1. 컨테이닝앱  :앱 익스텐션의 기반이 되는 앱 , 우리가 사용하는 그 앱
    2. 호스트앱  : 앱 익스텐션을 실제로 실행시키는 앱
        1. 예를들어 문자 앱에서 유튜브 익스텐션을 실행하는 경우. 컨테이닝 앱은 유튜브, 호스티앱은 문자 
    ![](https://i.imgur.com/R67DlBN.png)

1. 컨테이닝앱과 앱 익스텐션은 어떻게 소통하는가?
    ![](https://i.imgur.com/rKbV29E.png)


    - 직접적인 상호작용은 없다.
    
    ⇒ Shared Resources를 활용한다. 
    ![](https://i.imgur.com/tzitOA2.png)

    ex
    
    - App Group → Userdefaults
    - App Group → File Container
    - App Group → Shared CoreData
    
2. 위젯은 언제 부터 시작되었나?
    1. iOS13 까진 `Today Extension`
    2. iOS14부터 `Widget Extension`

1. 위젯의 작동방식
    
    
    프로바이더와 엔트리가 시스템에 알려줌(시스템이gettimeline을 호출했을 때)
    
    위젯도 서버와 통신이 가능한데 보통 이 구현을 gettimeline 내부에서 구현 
    
    - 엔트리 : 업데이트할 때 무엇을 할 지 결정
        - 엔트리배열 : 엔트리가 업데이트 시간표 전달
    
    시스템은 정해진 시각에 맞춰 EntryView를 갱신 
    
    - 시스템은 업데이트 시간에 맞춰 동작수행(뷰 업데이트)
    
2. policy
    
    - atEnd : 업데이트 주기 끝난다음 다시 시작해줘 
    
    - after : 업데이트 주기 중에 다시 타임라인 refresh할 거야
    
    - never : 업데이트 주기가 끝난 다음에 다시 알려줄 때까지 업데이트 하지 않음
    

1. 위젯은 link 이용한 상호작용이 가능
    1. 작은 것은 1개의 링크만
    2. 미디엄, 라지는 여러개의 링크를 연결할 수 있음
    
2. Configuration
    1. Static은 사용자가 수정 못하도록
    2. Intent는 사용자 설정 다양하게 가능하다!


### 참고문서
https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension
https://developer.apple.com/documentation/WidgetKit/Keeping-a-Widget-Up-To-Date
https://nsios.tistory.com/156
