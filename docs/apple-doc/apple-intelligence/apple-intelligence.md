---
source_url: https://developer.apple.com/documentation/TechnologyOverviews/apple-intelligence
title: Apple Intelligence
category: apple-intelligence
kind: article
fetched_at: 2026-11-04T00:00:00Z
---

Technology Overviews
Apple Intelligence
Adopt intelligent features, like Writing Tools and Genmoji, and help people search with Visual Intelligence.
Overview

Apple Intelligence is the personal intelligence system behind many built-in capabilities, and you use it to create contextually relevant and personal experiences for people. Integrate your app’s actions and data with Apple Intelligence to enhance system features like Siri, Spotlight, and Shortcuts. Customize your app’s content with features like Writing Tools, Image Playgrounds, Visual Intelligence, and Genmoji, which use Apple Intelligence to enhance your content.

Build intelligent experiences that run on Apple devices and in Private Cloud Compute by using Generative models and machine learning that power Apple Intelligence.

Teach the system about your app’s actions and data

One of the best ways to embrace intelligent features is to make the system aware of your app’s actions and data. In addition to apps, people interact with content using Apple Intelligence, Siri, Spotlight, Shortcuts, and other system features. Those features interact with your content using app intents and app entities you provide using the App Intents framework.

An app intent is a custom type that encapsulates one of your app’s actions. Create app intents for the actions that people commonly perform, and ship them with the rest of your app’s code. For example, a music app might contain an app intent to play a song or playlist, and an alarm clock app might contain an app intent to create a new alarm. In addition to the code to perform an action, app intents can have parameters and return results. Include the code for app intents in your app or in an app extension you use to handle interactions when your app isn’t running.

If app intents are your app’s actions, app entities represent the data you need to perform those actions. Create app entities for the subset of your app’s data that people need and might refer to during interactions with Siri or other system features. For example, a music app might provide entities for songs, albums, and playlists, but not for the database it uses to manage its music library. To ensure that interactions with the system are fast, make your app entities lightweight and something you can create quickly in your code.

While your app is running, donate app intents and app entities to reflect people’s interactions with your content. The system uses donated app intents and entities to improve the experience of using your app. For example, if someone performs the same action every day, the system might preemptively suggest that action at the appropriate time. Apple Intelligence uses donated app entities to identify data in your app’s interface, which Siri can use as additional context during a conversation. The system can also retrieve the entities it finds in your app’s Spotlight index, and use them to interact with your content.

Enhance people’s writing process in your app

To help people improve the quality of their writing, add proofreading and rewriting tools to your app by adopting the Writing Tools API. The standard system text views already integrate support for Writing tools, and you can customize the experience to suit your app’s needs. You can also add Writing Tools support to your app’s custom text views using the provided APIs. When adding Writing Tools to your app:

Adopt attributed strings as the backing store for your text content.

Display text using the standard text views whenever possible, and use the configuration options to customize the behavior.

Use the Writing Tools API if you have a custom text editing engine or can’t use the system text views.

Generate images and Genmoji from concepts

The Image Playground app gives people a way to personalize their images. Bring this same capability to your app using the Image Playground framework. This framework offers a standard interface for generating new images using Apple Intelligence. For example, use it to generate stylized images for use in your app, such as someone’s profile photo. To generate images programmatically, use the same conceptual input.

Genmoji are custom emoji that people create and integrate into their text content. If you use the system-provided text views, support for Genmoji is built-in. To add support to custom views, add Genmoji text attachments. To persist your app’s text to a custom file format, be sure to read and write these attachments correctly with the rest of your content.

Support searches of your app’s image content

To help people find more information about the places and objects around them, adopt visual intelligence. People can use visual intelligence to receive information about objects they scan using the Camera Control on supported iPhone devices. The framework provides information about what it detects, and uses App Intents to exchange that information with your app.
