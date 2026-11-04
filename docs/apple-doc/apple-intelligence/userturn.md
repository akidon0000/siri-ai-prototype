---
source_url: https://developer.apple.com/documentation/sirievaluations/userturn
title: UserTurn
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
UserTurn
A single utterance a person says, with what you expect Siri to do in response.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct UserTurn
Overview

A user turn is one thing the person says to Siri. Create a turn with only an utterance to give Siri context for a later turn, or add a closure of expectations to check what Siri does in response. A turn accepts Calls, Finds, OnScreen, Loads, and SiriResponse expectations. It compares them only with that turn, so something Siri does in another turn can’t satisfy them.

Each turn has an id. After a run, the framework matches each action Siri performs to its turn by identifier. A run that stops early never checks one turn’s expectations against another turn.

The following shows a turn that expects Siri to start a science quiz, not to create a reminder, and to include the name of the topic in its reply:

let quizExampleIntents = IntentDefinitions(bundleIdentifier: "com.example.QuizExample")
let startQuizIntent = quizExampleIntents.intents["StartQuizIntent"]
let createQuizReminderIntent = quizExampleIntents.intents["CreateQuizReminderIntent"]

UserTurn("In QuizExample, start a science quiz with 5 questions") {
    Calls {
        startQuizIntent
            .expect(topic: .equals("Science"))
    }

    // Fails if Siri runs or asks the person to confirm the intent.
    Calls(.disallowed) {
        createQuizReminderIntent
    }

    // Checks if the reply names the topic.
    SiriResponse(.contains("Science"))
}

Place turns in a SiriScenario to run them as a conversation.

Topics
Creating a user turn
init(String)
Creates a turn with no expectations of its own.
Creating a user turn with expectations
init(String, () -> SiriTurnExpectationBuilder.Component)
Creates a turn from an utterance and what Siri should do in response to it.
enum SiriTurnExpectationBuilder
A result builder that collects the expectations you attach to a user turn.
Inspecting a user turn
let id: UUID
An identifier for the turn.
let utterance: String
The text a person says to Siri in this turn.
Relationships
Conforms To
Decodable
Encodable
Identifiable
Sendable
SendableMetatype
See also
Scenarios
struct SiriScenarioLoader
A loader that supplies the scenarios an evaluation runs, in the order you write them.
Beta
struct SiriScenario
An ordered, multiturn interaction run in one Siri session.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
