import AppIntents

// ○ Make a tool: can be asked for in one sentence that fills in the parameters
// "Make the milk memo high priority" has both memo and priority in one sentence
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* built in the next section */ }

// × Don't: intents that follow a Siri-enabled schema are already exposed to Siri
// Writing @AppIntent(.tool, schema: .reminders.createReminder) is a build error
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* chapter 5 */ }
