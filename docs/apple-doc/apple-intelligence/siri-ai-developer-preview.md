---
source_url: https://developer.apple.com/documentation/appintents/siri-ai-developer-preview
title: Siri AI Developer Preview
category: apple-intelligence
kind: article
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
API Collection
Siri AI Developer Preview
Bring custom actions and content to Siri AI.
Overview

With the Siri AI Developer Preview, Siri can understand context, find content, and perform actions not only for functionality and data that fits system-defined app schema domains, but also for custom actions and information.

Note

Siri can only find custom content and perform custom actions an app makes explicitly available using App Intents.

With the Siri AI Developer Preview:

Siri can find your custom content and perform your app’s custom actions. People don’t have to mention your app in their request while your app is in the foreground, while a Live Activity is active, or when a person continues a conversation in the Siri app that includes a mention of your app. For example, a person might request a ride with a ride share app, follow updates to the app’s Live Activity while they wait for their ride to arrive, then request to move the pickup location to a different address by saying “Hey Siri, change my ride pickup to a new address.”

Siri can find custom content and perform actions when your app is in the background if someone mentions your app in their request. For example, a person might say “Hey Siri, are the sneakers I liked in app name on sale?” Siri understands that the person liked a pair of sneakers in the mentioned app and provides the information.

Siri can find custom content from one app, transfer it to a specified app, and perform an action. For example, somebody might request “Hey Siri, send my favorite sneakers to my partner in name of a messaging app.” Siri finds sneakers that the person added to their favorites, understands who the partner is, finds them in Contacts, then sends the sneaker information to them using the messaging app.

Siri displays custom content a person requests in card snippets that you provide. The card snippets include the requested information and use your custom views to show your app’s branding and personality.

To make your custom app intents and entities available to the Siri AI Developer Preview, update your existing App Intents code as described in Bringing custom actions and content to Siri. You don’t need to add a new entitlement or join a separate developer program.

To perform complex custom actions and handle unique content that people include in ambiguous requests, Siri might need additional guidance to understand your app’s unique domain. For example, to perform the same action with Siri, someone might use either of the following to form their request:

“Siri, compare shoes on sale that match my style.”

“Hey Siri, are prices for sneakers I like lower than usual?”

To provide additional guidance to Siri for complex tasks, create app skills as described in Orchestrating complex actions with app skills.

The Siri AI Developer Preview includes features to help you improve how your app intents work with Siri:

The Siri Integration Advisor in Xcode provides feedback and suggestions that help you improve your App Intents implementation to enable Siri to perform your app’s custom actions and handle its custom data.

The Siri Evaluations framework lets you script requests to Siri, measure how Siri handles them, and catch changes in how Siri responds as you update your intents and entities.

Important

The Siri AI Developer Preview is available in iOS, iPadOS, macOS, and visionOS on devices that support Apple Intelligence. During the preview, App Intents API and Siri functionality may change.

During the Siri AI Developer Preview, test your integration with the new Siri AI capabilities using the following methods:

Build your app with Xcode, sign it with a development profile, and run it on a device that supports the Siri AI Developer Preview.

Make versions of your app available to internal testers in TestFlight.

The Siri AI Developer Preview isn’t available to external testers in TestFlight or to versions of your app that you publish on the App Store. If your app uses App Intents API to integrate custom actions and content with the preview, the functionality that the Siri AI Developer Preview provides isn’t available to external testers or people who get your app from the App Store. For more information about distributing apps to internal testers, see App Store Connect Help.

Topics
Getting started
Bringing custom actions and content to Siri
Support the Siri AI Developer Preview by turning custom app intents into tools Siri can call, and by helping Siri understand your app entities.
Orchestrating complex actions with app skills
Guide Siri AI through a complex task that involves several tool intents by providing an app skill.
Tool support
macro AppIntent(AppIntentTraits)
Makes an existing app intent available to Siri as a tool.
macro AppIntent<T>(AppIntentTraits, schema: T)
Makes an app intent that conforms to a schema available to Siri as a tool.
struct AppIntentTraits
The roles an app intent takes on, passed to @AppIntent.
struct IntentVisibility
A value that configures how a property is available to system features, such as Siri and Shortcuts, if at all.
protocol ToolIntent
A protocol that identifies an app intent that Siri can call while handling a person’s request.
Entity support
protocol GenerableEntity
An interface that tells a model it can create an entity and fill in its properties directly.
macro AppEntity(AppEntityTraits)
Marks a transient entity whose values the model can generate on its own.
macro AppEntity<T>(AppEntityTraits, schema: T)
Marks a transient entity that conforms to a schema as one whose values the model can generate on its own.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, customIndexingKey: CSCustomAttributeKey)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.
struct AppEntityTraits
The roles an app entity takes on, passed to @AppEntity.
