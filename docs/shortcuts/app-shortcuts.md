---
source_url: https://developer.apple.com/documentation/appintents/app-shortcuts
title: App Shortcuts
category: shortcuts
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
API Collection
App Shortcuts
Improve the experience of using your app intents and entities in system experiences like Siri, Spotlight, and the Shortcuts app.
Overview

App Shortcuts provide a polished experience for your app intents and entities in the Shortcuts app and other system experiences. An App Shortcut combines the action from your app intent with other data, such as a title, image, and spoken phrases that someone might use to run the shortcut. A shortcut can also contain preconfigured parameters, so someone can run the action quickly, and without having to specify additional information. For example, a hiking app might offer an app intent to start a hike, but require you to select a trail before starting the action. Without a shortcut, someone must provide the trail information each time they run the intent. However, a shortcut can simplify this flow by offering to start a hike on the person’s favorite trail.

You create App Shortcuts programmatically in your code, and the compiler generates the information the rest of the system needs to use it. This approach means that the shortcuts you create are available as soon as someone installs your app, and you don’t have to register them yourself. Specify your shortcuts in your code by defining a custom type that adopts the AppShortcutsProvider protocol. Include this type in your app, app extension, Swift package, or library that you use to manage your intents-related code. Inside this type, construct one or more AppShortcut types using static data. Define your shortcuts in the same place you define the app intents that those shortcuts use.

Note

Apple may extract anonymized App Shortcuts data such as localized phrases, display representation values, and the title and description of related intents. Machine learning models use this data when training to help improve the App Shortcuts experience.

Although the Shortcuts app and other system features find your shortcuts automatically, you can also make them available from your app using tip views. The SiriTipView and SiriTipUIView types display the relevant shortcuts for the app intent you specify. You can also use a ShortcutsLink or ShortcutsUIButton to open your app’s page in the Shortcuts app.

Topics
App Shortcut management
protocol AppShortcutsProvider
A type alias for the type that provides an app’s preconfigured shortcuts.
App Shortcut definition
struct AppShortcut
A type that defines a preconfigured shortcut for a specific app intent.
struct AppShortcutPhrase
A spoken phrase that causes the system to run the corresponding App Shortcut.
enum AppShortcutPhraseToken
Dynamic values you can include in the spoken phrases that run your shortcut.
struct NegativeAppShortcutPhrase
An object that represents a negative phrase.
struct NegativeAppShortcutPhrases
This is a set of negative phrases, which will all be added to the app-level negative training set. All the training data specified here, will be used to completely bypass your app
NSAppIconActionTintColorName
The tint color to apply to text and symbols in the App Shortcuts platter.
NSAppIconComplementingColorNames
The names of the colors to use for the background of the App Shortcuts platter.
enum AppShortcutsBuilder
A result builder that allows you to declaratively describe the App Shortcuts that your app provides.
enum ShortcutTileColor
Describes the colors a shortcut tile in the Shortcuts app.
protocol AppShortcutsContent
App Shortcut options
struct AppShortcutOptionsCollection
Represents a collection of options for parameters of an App Shortcut.
protocol AppShortcutOptionsCollectionProtocol
protocol AppShortcutOptionsCollectionSpecification
enum AppShortcutOptionsCollectionSpecificationBuilder
App Shortcut parameter presentation
struct AppShortcutParameterPresentation
Describes the presentation of an App Shortcut for the provided parameter.
struct AppShortcutParameterPresentationSummary
The summary of the presentation of an App Shortcut parameter.
struct AppShortcutParameterPresentationSummaryString
struct AppShortcutParameterPresentationTitle
A struct that represents the title of the presentation of an App Shortcut.
Deprecated
struct AppShortcutParameterPresentationTitleString
Deprecated
Buttons
class ShortcutsUIButton
A button that opens the current app’s page in the Shortcuts app.
struct ShortcutsLink
A button that brings users to the current app’s App Shortcuts page in the Shortcuts app.
struct ShortcutsLinkStyle
The styles to apply to buttons you use to open your app’s page in the Shortcuts app.
Tip views
class SiriTipUIView
A view that displays the phrase a person uses to invoke an App Shortcut.
struct SiriTipView
A SwiftUI view that displays the phrase someone uses to invoke an App Shortcut.
struct SiriTipViewStyle
The styles to apply to the tip views you use to display spoken phrases.
See also
Feature integration
Adopting App Intents to support system experiences
Create app intents and entities so people can use your app’s content and actions across system experiences.
Apple Intelligence and Siri AI
Integrate your app with Apple Intelligence and bring it to Siri AI.
Spotlight integration
Add your entities to your app’s Spotlight index, and automate the indexing of your content.
Widgets, Live Activities, and Controls
Implement interactive widgets, controls, watch complications, and Live Activities using app intents.
Hardware interactions
Run your App Shortcuts from the Action button on iPhone or Apple Watch, or launch your own conversational app from the side button on iPhone.
Focus
Adjust your app’s behavior and filter incoming notifications when the current Focus changes.
Visual intelligence
Match images to your app’s content and report the results to the Visual Intelligence framework using an app intent.
