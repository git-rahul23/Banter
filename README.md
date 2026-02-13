# Banter

A modern, AI-powered chat application built with SwiftUI that delivers intelligent conversations with a clean, intuitive interface.

## Overview

Banter is an iOS chat application that enables seamless conversations with an AI agent. Built with native iOS technologies, it provides a responsive and polished user experience with support for text and image messages, real-time typing indicators, and persistent conversation history.

## Screenshots

<div align="center">
  <img src="screenshots/launcher.png" width="250" alt="Launch Screen">
  <img src="screenshots/chat-list.png" width="250" alt="Chat List">
  <img src="screenshots/chat-detail.png" width="250" alt="Chat Detail">
</div>

## Demo Video

Watch Banter in action! This screen recording showcases the app's key features including creating new chats, sending messages, real-time typing indicators, and the smooth user experience.

<video src="screenshots/demo.mp4" width="300" controls></video>

> **Note:** If the video doesn't play above, you can [download it here](screenshots/demo.mp4) or view it directly in the `screenshots` folder.

<details>
<summary>📱 What's shown in the demo</summary>

- App launch with custom splash screen
- Browsing existing conversations with message previews
- Creating a new chat
- Sending text messages
- Real-time typing indicators
- Smooth animations and transitions
- Chat management features
- Image sharing capabilities

</details>

## Features

- **Smart Conversations**: Engage in natural conversations with an AI agent
- **Image Support**: Share and view images within conversations
- **Real-time Typing Indicators**: See when the agent is composing a response
- **Persistent Storage**: All conversations are saved locally using Core Data
- **Clean UI**: Modern SwiftUI interface with smooth animations
- **Empty States**: Friendly prompts to guide users when starting new conversations
- **Message Timestamps**: Smart time formatting (relative for recent, absolute for older messages)
- **Chat Management**: Create, rename, and delete conversations

## Architecture

### MVVM Pattern

Banter follows the **Model-View-ViewModel (MVVM)** architecture pattern for several key reasons:

1. **Separation of Concerns**: Business logic is separated from UI code, making the codebase more maintainable and testable
2. **SwiftUI Integration**: MVVM pairs naturally with SwiftUI's declarative syntax and state management using `@Published` properties
3. **Testability**: ViewModels can be tested independently without requiring UI components
4. **Reusability**: Business logic in ViewModels can be shared across different views
5. **Clarity**: Clear data flow from Model → ViewModel → View makes the code easier to understand and debug

**Structure:**
- **Models**: Core Data entities (`Chat`, `Message`) and domain models (`MessageFile`, `MessageSender`)
- **Views**: SwiftUI views (`ChatListView`, `ChatDetailView`, `MessageBubbleView`)
- **ViewModels**: State management and business logic (`ChatListViewModel`, `ChatDetailViewModel`)

### Core Data

**Core Data** was chosen as the persistence layer for the following reasons:

1. **Native Integration**: First-party Apple framework with excellent Swift support
2. **Relationship Management**: Effortlessly handles the one-to-many relationship between Chats and Messages
3. **Performance**: Lazy loading and faulting ensure efficient memory usage even with large conversation histories
4. **Sorting & Filtering**: Built-in NSFetchRequest capabilities for complex queries
5. **Data Migration**: Supports schema changes with automatic and manual migration options
6. **Thread Safety**: NSManagedObjectContext provides built-in concurrency management

**Data Model:**
```
Chat (1) ←→ (Many) Messages
- Chat: id, title, lastMessage, lastMessageSender, lastMessageTimestamp, createdAt, updatedAt
- Message: id, chatId, message, typeRaw, senderRaw, filePath, fileSize, thumbnailPath, timestamp
```

### Dependency Injection

The app uses **constructor-based dependency injection** for the `ChatDataService`:

```swift
// Service is injected at the app level
@StateObject private var dataService = ChatDataService(context: persistenceController.container.viewContext)

// Passed down through the view hierarchy
ChatListView(dataService: dataService)

// ViewModels receive it through initialization
init(dataService: ChatDataService) {
    self.dataService = dataService
}
```

**Benefits:**
1. **Testability**: Easy to inject mock services during testing
2. **Flexibility**: Can swap implementations without changing dependent code
3. **Explicit Dependencies**: Clear view of what each component needs
4. **Single Source of Truth**: One shared instance manages all data operations
5. **Lifecycle Management**: `@StateObject` ensures the service persists for the app lifetime

## Project Structure

```
Banter/
├── App/
│   ├── BanterApp.swift           # App entry point
│   └── Launch Screen.storyboard  # Launch screen configuration
├── Features/
│   ├── ChatList/
│   │   ├── ChatListView.swift
│   │   ├── ChatListViewModel.swift
│   │   └── ChatRowView.swift
│   └── ChatDetail/
│       ├── ChatDetailView.swift
│       ├── ChatDetailViewModel.swift
│       └── MessageBubbleView.swift
├── Models/
│   ├── Chat+CoreDataClass.swift
│   ├── Chat+CoreDataProperties.swift
│   ├── Message+CoreDataClass.swift
│   └── Message+CoreDataProperties.swift
├── Services/
│   ├── ChatDataService.swift     # Core Data operations
│   ├── AgentService.swift        # AI agent integration
│   └── PersistenceController.swift
├── Components/
│   ├── MessageInputBar.swift
│   ├── TypingIndicatorView.swift
│   ├── ImagePickerView.swift
│   └── FullscreenImageView.swift
└── Utilities/
    ├── Constants.swift            # App-wide constants
    ├── TimestampFormatter.swift   # Smart time formatting
    └── ImageSaver.swift           # Image persistence
```

## Setup Instructions

### Prerequisites

- **Xcode 15.0+** (or later)
- **iOS 17.0+** deployment target
- **macOS Ventura 13.0+** (for development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Banter
   ```

2. **Open the project:**
   ```bash
   open Banter.xcodeproj
   ```

3. **Build and run:**
   - Select your target device or simulator in Xcode
   - Press `Cmd + R` to build and run the app
   - The app will launch with sample conversations pre-loaded

### First Launch

On first launch, the app automatically seeds sample conversations to demonstrate functionality. These can be deleted from the UI if desired.

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Persistent data storage
- **Combine**: Reactive state management
- **UIKit Integration**: Camera and photo library access via UIViewControllerRepresentable
- **Swift Concurrency**: Async/await for image processing

## Requirements

- iOS 17.0 or later
- iPhone or iPad

## License

[Add your license here]

## Author

Rahul Rana

---

Built with ❤️ using SwiftUI and Core Data
