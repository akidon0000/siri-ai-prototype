---
source_url: https://developer.apple.com/documentation/sirievaluations/siriscenarioloader
title: SiriScenarioLoader
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
SiriScenarioLoader
A loader that supplies the scenarios an evaluation runs, in the order you write them.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct SiriScenarioLoader
Overview

A scenario loader is the dataset of a Siri evaluation. It holds the scenarios you pass in, and the evaluation runs each one through Siri in that order. The loader’s closure accepts individual scenarios or arrays of scenarios, so you can combine scenarios you define separately with ones you build from a collection.

The loader holds scenarios but doesn’t set up your app. Set up any app state in your test before the evaluation runs, and group scenarios that start from the same state in one loader. Scenarios that need a different starting state belong in their own evaluation and test because setup runs once per test, not between scenarios.

This example combines separate scenarios in a loader:

let quizExampleIntents = IntentDefinitions(bundleIdentifier: "com.example.QuizExample")
let startQuizIntent = quizExampleIntents.intents["StartQuizIntent"]
let openQuizIntent = quizExampleIntents.intents["OpenQuizIntent"]
let quizTopicEntity = quizExampleIntents.entities["QuizTopicEntity"]

// A scenario you define separately.
let openScienceQuiz = SiriScenario {
    UserTurn("Open the Science quiz in QuizExample") {
        Calls {
            openQuizIntent
                .expect(target: quizTopicEntity.expectIdentifier("Science"))
        }
    }
}

let topics = ["Science", "History", "Geography"]

let dataset = SiriScenarioLoader {
    // Include the scenario you defined separately.
    openScienceQuiz

    // Add one scenario for each topic.
    topics.map { topic in
        SiriScenario {
            UserTurn("In QuizExample, start a \(topic.lowercased()) quiz") {
                Calls {
                    startQuizIntent
                        .expect(topic: .equals(topic))
                }
            }
        }
    }
}
    
// Pass the loader to your custom evaluation type.
let evaluation = QuizExampleEvaluation(name: "Quiz requests", dataset: dataset)

Topics
Creating a loader
init(() -> SiriScenarioLoader)
Creates a loader that supplies the scenarios a builder closure produces, in the order written.
enum SiriScenarioLoaderBuilder
A result builder that collects scenarios into one dataset.
Loading scenarios
let scenarios: [SiriScenario]
The scenarios, in the order written.
var stream: any AsyncSequence<SiriScenario, any Error>
An asynchronous sequence that delivers the scenarios in the order written.
typealias Sample
The type of sample this loader supplies.
Relationships
Conforms To
Loader
Sendable
SendableMetatype
See also
Scenarios
struct SiriScenario
An ordered, multiturn interaction run in one Siri session.
Beta
struct UserTurn
A single utterance a person says, with what you expect Siri to do in response.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
