---
source_url: https://developer.apple.com/documentation/appintents/intentvisibility
title: IntentVisibility
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Structure
IntentVisibility
A value that configures how a property is available to system features, such as Siri and Shortcuts, if at all.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
Mac Catalyst 27.3+
Beta
macOS 27.3+
Beta
tvOS 27.3+
Beta
visionOS 27.3+
Beta
watchOS 27.3+
Beta
struct IntentVisibility
Overview

System features such as Siri and Shortcuts list an app entity’s properties to people and to the model when you apply the default option. However, you can limit a property’s visibility to just your app and its extensions by applying the internal option. For example, apps typically apply this option to properties with sensitive information.

struct Contact: AppEntity {
    @Property(title: "Tax ID", visibility: .internal)
    var taxID: String
}

Note

Don’t combine the internal option with an indexing key for Spotlight, such as indexingKey or customIndexingKey, because the keys make the property discoverable from Spotlight.

Topics
Type Properties
static var `default`: IntentVisibility
A visibility option that makes the property available to your app and to system features, such as Siri and Shortcuts.
static var `internal`: IntentVisibility
A visibility option that limits the property to your app and its extensions.
Relationships
Conforms To
Equatable
Hashable
Sendable
SendableMetatype
See also
Tool support
macro AppIntent(AppIntentTraits)
Makes an existing app intent available to Siri as a tool.
macro AppIntent<T>(AppIntentTraits, schema: T)
Makes an app intent that conforms to a schema available to Siri as a tool.
struct AppIntentTraits
The roles an app intent takes on, passed to @AppIntent.
protocol ToolIntent
A protocol that identifies an app intent that Siri can call while handling a person’s request.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
