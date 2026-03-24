# ToDoList

`ToDoList` is a test iOS application for managing tasks. The app is built on `UIKit` without storyboards for the main flow, uses `Core Data` for local storage, and on the first launch imports an initial list of tasks from `https://dummyjson.com/todos`.

## What the app can do

- display a list of tasks in a `UITableView`
- search tasks by title and description
- mark tasks as completed directly from the list
- open a task card with actions
- create new tasks
- edit existing tasks
- delete tasks
- share a task through `UIActivityViewController`
- persist data locally with `Core Data`

## How it works

On first launch, the app checks whether there are saved tasks in local storage:

- if `Core Data` is empty, tasks are loaded from the remote API
- the received data is saved locally
- all subsequent work happens with local data

This means the network is needed only for the initial import when the database is empty.

## Tech Stack

- `Swift 5`
- `UIKit`
- `Core Data`
- `URLSession`
- `XCTest`
- Coordinator-based navigation
- Presenter-based screen logic
- fully programmatic UI for the main screens

## Architecture

The project is split into several layers:

- `Application` - app entry point, `AppDelegate`, `SceneDelegate`, root coordinator
- `Screens` - app screens, presenters, protocols, builders, routing
- `CoreData` - persistence layer, entity model, manager and error types
- `Packages/Core` - network and decoding services
- `Packages/Navigation` - abstractions for navigation and coordinators
- `Packages/DesignSystem` - small UI and utility extensions

Navigation is built through `AppCoordinator` -> `FlowCoordinator`, and screen dependencies are assembled in `ScreenBuilder` and `ToDoDiContainer`.

## Main Screens

### Task List

Main screen with:

- title block
- search row
- list of tasks
- footer with task counter and button for creating a new task

### Task Card

Opens selected task and allows:

- edit
- share
- delete

### Create Task

Screen for creating a new task with title and description fields.

### Edit Task

Screen for editing an existing task.

## Project Structure

```text
ToDoList/
├── CoreData/
│   ├── CoreDataManager.swift
│   ├── PersistenceController.swift
│   └── ToDoEntity.xcdatamodeld
├── ToDoList/
│   ├── Application/
│   ├── Packages/
│   │   ├── Core/
│   │   ├── DesignSystem/
│   │   └── Navigation/
│   └── Screens/
│       ├── ToDoList/
│       ├── Task/
│       ├── CreateTask/
│       └── EditTask/
└── ToDoListTests/
```

## Run

### In Xcode

1. Open [ToDoList.xcodeproj](/Users/albert_nastya/Desktop/Develop/SwiftProjectsForEmployment/EffectiveMobile/TestTask/ToDoList/ToDoList.xcodeproj).
2. Select scheme `ToDoList`.
3. Choose any available iOS Simulator.
4. Run the app with `Cmd + R`.

### From terminal

Build:

```bash
xcodebuild -project ToDoList.xcodeproj -scheme ToDoList -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Tests:

```bash
xcodebuild test -project ToDoList.xcodeproj -scheme ToDoList -destination 'platform=iOS Simulator,name=iPhone 16'
```

If the selected simulator is unavailable, replace `iPhone 16` with a device present in your local Xcode environment.

## Requirements

- `Xcode 16+`
- `iOS 18.2+` deployment target

## Tests

The project currently contains unit tests for `DecoderService`:

- successful JSON decoding
- failure on mismatch between model and JSON structure

## Notes

- The project does not use third-party dependencies.
- Main UI is created in code; storyboard is used only for `LaunchScreen`.
- Imported tasks from the remote API use the same text for both title and description because the source response contains a single `todo` field.

## Possible Improvements

- add tests for presenters and `CoreDataManager`
- extract repository layer between presentation and storage/network
- add validation and user-facing error handling
- sort and group tasks
- add empty/loading/error states
- add dependency injection for `CoreDataManager.shared` usage inside presenter logic
