---
source_url: https://developer.apple.com/documentation/appintents/apple-intelligence-and-siri-ai
title: Apple Intelligence and Siri AI
category: apple-intelligence
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
API Collection
Apple Intelligence and Siri AI
Integrate your app with Apple Intelligence and bring it to Siri AI.
Overview

Apple Intelligence combines language models with your app’s actions and content to power Siri AI. It uses the app intents, app entities, and app enumerations you define to access your app’s actions, content, and skills.

Perform these steps to make actions and content discoverable by Apple Intelligence and Siri AI:

Index entities to make them available in Spotlight. Apple Intelligence uses the semantic search capabilities of Spotlight to find your app’s content, even when someone describes it vaguely.

Choose transferable types. Conforming your AppEntity to Transferable or types from the App Intents framework enables the system to move content across apps so people can perform tasks across apps with Siri AI.

Adopt schemas. Schemas define the structure of your app intents, app entities, and app enums. Schemas act as a contract between your app and the system; Apple Intelligence uses them to identify, query, and understand actions and content. Siri AI uses the schemas to match actions and content to phrases people say in everyday conversation.

Associate entities with views and other structures. People use Siri AI to interact with content that’s visible onscreen, but that content is private to your app. Associating views, user activities, or other visible content with app entities gives Apple Intelligence onscreen context. For example, onscreen context lets someone refer to an onscreen photo conversationally as “this photo”.

Donate actions and content. Donations give Apple Intelligence behavioral cues to identify trends, predict future behavior, and disambiguate vague requests. For example, if someone asks your app for the weather each morning, Apple Intelligence can proactively suggest the same action.

Topics
Siri AI Developer Preview
Siri AI Developer Preview
Bring custom actions and content to Siri AI.
Content
Defining app entities for your custom data types
Provide the system with information about the types your app uses to model its data so that your intents can use those types as parameters.
Making app entities available in Spotlight
Update your app entity types to support Spotlight indexing, and donate entities to make them findable in searches.
Onscreen context
Providing contextual cues to Apple Intelligence and Siri
Annotate your interface with app entities to offer contextual information about your app’s onscreen content.
App schema domains
Declare support for well-known actions and content by applying system-defined schemas to your app intents, app entities, and app enumerations.
protocol UITableViewAppIntentsDataSource
The methods that an object adopts to make items in a table view discoverable by Apple Intelligence and Siri.
protocol NSTableViewAppIntentsDataSource
The methods that an object adopts to make items in a table view or outline view discoverable by Apple Intelligence and Siri.
protocol UICollectionViewAppIntentsDataSource
The methods adopted by the object you use to make items in a collection view discoverable by Apple Intelligence and Siri.
protocol NSCollectionViewAppIntentsDataSource
The methods adopted by the object you use to make items in a collection view discoverable by Apple Intelligence and Siri.
Actions
Making actions and content discoverable by Apple Intelligence
Equip the system so that Siri can work with your app by adding specific schemas from relevant domains.
Donating your app’s data and actions to the system
Improve how people interact with your app through Apple Intelligence and Siri by teaching the system about your app’s data and actions.
Sample code
Integrating your messaging app with Apple Intelligence
Adopt message schemas so people can send messages and manage conversations with Siri.
Integrating your calendar app with Apple Intelligence
Adopt calendar schemas so people can create, find, and manage events with Siri.
Integrating your music app with Apple Intelligence
Adopt the audio and clock schemas so people can play music and set alarms with Siri.
Integrating your photo app with Apple Intelligence
Adopt photo schemas so people can edit and manage photos with Siri.
See also
Feature integration
Adopting App Intents to support system experiences
Create app intents and entities so people can use your app’s content and actions across system experiences.
Spotlight integration
Add your entities to your app’s Spotlight index, and automate the indexing of your content.
App Shortcuts
Improve the experience of using your app intents and entities in system experiences like Siri, Spotlight, and the Shortcuts app.
Widgets, Live Activities, and Controls
Implement interactive widgets, controls, watch complications, and Live Activities using app intents.
Hardware interactions
Run your App Shortcuts from the Action button on iPhone or Apple Watch, or launch your own conversational app from the side button on iPhone.
Focus
Adjust your app’s behavior and filter incoming notifications when the current Focus changes.
Visual intelligence
Match images to your app’s content and report the results to the Visual Intelligence framework using an app intent.
