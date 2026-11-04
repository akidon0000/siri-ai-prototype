---
source_url: https://developer.apple.com/documentation/sirievaluations/onscreen
title: OnScreen
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
OnScreen
An expectation that specific app entities are onscreen.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct OnScreen
Overview

Use OnScreen to check that an entity is in the onscreen context Siri captures for a turn. OnScreen doesn’t show the entity itself, so before the evaluation runs, make sure your app is displaying it. For example, run an App Intent that opens the screen that shows the entity and then run the evaluation.

Unlike Finds, OnScreen matches by identity only and doesn’t use property constraints like .expect(title:). Write an empty entity definition to match any entity of that type, or call expectIdentifier(_:) to name a specific one.

The following example shows a turn that expects a specific quiz topic to be onscreen:

let quizExampleIntents = IntentDefinitions(bundleIdentifier: "com.example.QuizExample")
let quizTopicEntity = quizExampleIntents.entities["QuizTopicEntity"]

// The app is already showing the topic list.
UserTurn("Which quizzes are available in QuizExample?") {
    OnScreen {
        quizTopicEntity.expectIdentifier("Science")
    }
}

Topics
Creating an onscreen expectation
init(() -> [any ResolvableAppEntityExpectation])
Creates an expectation that each entity in the block is onscreen.
enum OnScreenEntityExpectationBuilder
A result builder that collects the entities an onscreen expectation requires.
Relationships
Conforms To
Decodable
Encodable
Sendable
SendableMetatype
See also
Expectations
struct Calls
An expectation that Siri calls, or doesn’t call, a set of intents during a turn or scenario.
Beta
struct Finds
An expectation that Siri surfaces specific app entities by search or resolution.
Beta
struct Loads
An expectation that Siri loads specific app skills.
Beta
struct SiriResponse
An expectation that the reply Siri gives contains specific text.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
