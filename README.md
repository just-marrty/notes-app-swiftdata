# MyNotesApp

A SwiftUI application for managing notes with full CRUD operations, utilizing SwiftData for local persistence and MVVM architecture with clean, modern UI and customizable theming.

**Note:** This application uses SwiftData framework for local data persistence, providing seamless note management without requiring a backend server.

## Features

- Browse notes with creation date sorting (newest first)
- Add new notes with automatic keyboard focus
- Edit existing notes with pre-populated content
- Delete notes via swipe gesture
- Real-time search functionality across note content
- Customizable color schemes (6 themes: Default Gray, Blue, Orange, Yellow, Green, Indigo)
- Dark mode support with persistent preference
- Automatic content validation (prevents saving empty notes)
- Clean and modern UI with SwiftUI
- Persistent settings using @AppStorage
- MVVM architecture with separated business logic
- Capsule-styled list rows with custom spacing

## Architecture

The project follows **MVVM (Model-View-ViewModel)** pattern with SwiftData for persistence:

### Models

#### Note

Main model representing a note:

- Decorated with `@Model` macro for SwiftData persistence
- **Properties:**
  - `content: String` - Note text content
  - `createdAt: Date` - Timestamp of note creation
- Automatically persists to local database
- Conforms to SwiftData's requirements

#### ColorBackground

Enum representing background color themes:

- Six color schemes: `gray`, `blue`, `orange`, `yellow`, `green`, `indigo`
- Conforms to `CaseIterable` for picker enumeration
- Raw string values for display and persistence
- **Computed property** `scheme: Color` returns themed colors:
  - Gray: Gray with 0.3 opacity (raw value: "default")
  - Blue: Blue with 0.5 opacity
  - Orange: Orange with 0.5 opacity
  - Yellow: Yellow with 0.5 opacity
  - Green: Green with 0.5 opacity
  - Indigo: Indigo with 0.5 opacity
- Used for consistent theming across the app

### ViewModels

#### NoteViewModel

ViewModel handling note validation and search logic:

- Decorated with `@Observable` macro for SwiftUI observation
- Marked with `@MainActor` for main thread execution
- **Properties:**
  - `content: String` - Editable note content for Add/Update views
- **Methods:**
  - `isNoteValid() -> Bool` - Validates non-empty content (trimmed)
  - `trimmedContent() -> String` - Returns trimmed content for saving
  - `search(for:from:) -> [Note]` - Filters notes by search term using dependency injection
- Business logic separated from UI for testability
- Reusable across Add, Update, and List views
- Pure function design for search (no side effects)

## Screens & Views

### MyNotesAppApp

Application entry point:

- Configures SwiftData model container for `Note` model
- Sets up `WindowGroup` with `NoteMainView` as root view
- Provides model context to entire app hierarchy

### NoteMainView

### NoteMainView

Main navigation shell and coordinator:

- Contains `NavigationStack` wrapping `NoteListView`
- Manages dark mode preference via `@AppStorage("isDarkOn")`
- Manages color scheme preference via `@AppStorage("scheme")`
- **Navigation bar:**
  - Title: "My Notes"
  - Leading: Settings gear icon (navigates to `NoteSettingsView`)
  - Trailing: Plus icon (navigates to `AddNoteView`)
- **Navigation configuration:**
  - Configures `.navigationDestination(for: Note.self)` for `NoteUpdateView`
- **Background styling:**
  - Hidden scroll content background (`.scrollContentBackground(.hidden)`)
  - Themed background based on selected color scheme
- Applies `preferredColorScheme` to entire navigation hierarchy
- Ensures consistent dark/light mode across all child views and navigation destinations

### NoteListView

Primary list view with search (MVVM pattern):

- Uses `@Query` macro for reactive data fetching from SwiftData
  - Sorted by `createdAt` in reverse order (newest first)
- Uses `@State` for `noteVM: NoteViewModel` instance
- Uses `@State` for `searchText: String` (bound to `.searchable`)
- Uses `@Environment(\.modelContext)` for delete operations
- **List directly calls search inline:**
  - `List(noteVM.search(for: searchText, from: notes))`
  - Filters by search text using `localizedStandardContains`
  - No intermediate computed property - direct function call
- **List row display shows:**
  - Note content (limited to 1 line)
  - Creation date (formatted, secondary color)
- **NavigationLink:**
  - Rows wrapped in `NavigationLink(value: note)`
  - Navigation destination configured in `NoteMainView`
- **Swipe actions:**
  - Delete button on trailing edge
  - Gray-tinted with trash icon (0.7 opacity)
  - Full swipe disabled for safety (`allowsFullSwipe: false`)
  - Deletes from context and saves immediately with error handling
- **Row styling:**
  - Capsule-shaped backgrounds with gray tint (0.3 opacity)
  - Custom insets (10pt vertical, 25pt horizontal)
  - Hidden row separators for clean look (`.listRowSeparator(.hidden)`)
  - 4pt padding around capsule
- **Search integration:**
  - Searchable with prompt "Search your note..."
  - Animated search results (`.animation(.default, value: searchText)`)

### AddNoteView

Form for creating new notes:

- Simple VStack layout with full-screen `TextEditor`
- Uses `@AppStorage("scheme")` for color scheme preference
- **Features:**
  - TextEditor bound to `$noteVM.content`
  - Autocorrection disabled
  - Automatic scroll keyboard dismissal (`.scrollDismissesKeyboard(.automatic)`)
  - **Automatic keyboard focus** using `@FocusState`
    - `showKeyboard: Bool` property
    - `.focused($showKeyboard)` modifier on TextEditor
    - Sets `showKeyboard = true` in `.onAppear`
    - Provides instant typing experience
- **Form validation:**
  - Uses ViewModel method `isNoteValid()`
  - Checks for non-empty trimmed content
  - Save button disabled when invalid (`.disabled(!noteVM.isNoteValid())`)
- **Visual styling:**
  - Themed background based on selected color scheme
  - Hidden scroll content background
  - Padding around TextEditor
- **Navigation bar:**
  - Title: "Add note" (inline display mode)
  - Trailing button: "Save" (disabled when invalid)
- **On save:**
  - Calls `noteVM.trimmedContent()` for cleaned content
  - Creates new `Note` instance with current `Date()`
  - Inserts into `modelContext`
  - Saves context with error handling (try-catch with print)
  - Dismisses view automatically via `dismiss()`
- Uses `@Environment(\.dismiss)` for navigation dismissal
- Uses `@Environment(\.modelContext)` for data persistence

### NoteUpdateView

Form for editing existing notes:

- Similar layout to `AddNoteView` with pre-populated content
- Receives `note: Note` parameter (let property)
- Uses `@AppStorage("scheme")` for color scheme preference
- **Pre-populates** content on appear:
  - Sets `noteVM.content = note.content`
  - Sets `showKeyBoard = true` for automatic keyboard focus
- **Features:**
  - Same `TextEditor` setup as AddNoteView
  - Automatic keyboard focus with `@FocusState` (`showKeyBoard: Bool`)
  - Content validation via ViewModel
- **Navigation bar:**
  - Title: "Edit note" (inline display mode)
  - Trailing button: "Update" (disabled when invalid)
- **On update:**
  - Gets trimmed content from `noteVM.trimmedContent()`
  - Updates existing `Note.content` in-place
  - Updates `Note.createdAt` to current date
  - Saves context with error handling
  - Dismisses view automatically
- Same visual styling and keyboard behavior as AddNoteView

### NoteSettingsView

Application settings and preferences:

- Form-based layout with two sections
- Uses `@AppStorage` directly (no AppState class)
- **Appearance section:** 
  - Toggle for dark/light mode
  - Dynamic label: Shows "Light mode" when dark, "Dark mode" when light
  - Green-tinted toggle (0.3 opacity)
  - Binds to `@AppStorage("isDarkOn")`
- **Color scheme section:** 
  - Picker for background theme selection
  - ForEach over `ColorBackground.allCases`
  - Displays capitalized color names via `.rawValue.capitalized`
  - Uses `.id(\.rawValue)` for ForEach identification
  - Binds to `@AppStorage("scheme")`
  - Automatic picker style
- **Uses @AppStorage for persistent settings:**
  - `isDarkOn: Bool` (default: false)
  - `schemeColor: ColorBackground` (default: .gray)
- **Visual styling:**
  - Gray-tinted section backgrounds (0.3 opacity)
  - Themed background based on selected color scheme
  - Hidden scroll content background
- Navigation title: "Settings"
- Applies `preferredColorScheme` based on `isDarkOn` setting
- Settings automatically sync across all views via `@AppStorage`

## SwiftData Integration

### Persistence Layer

- Model container configured in `MyNotesAppApp`
- `.modelContainer(for: Note.self, inMemory: false)` creates persistent store
- Automatic schema migration
- Local SQLite database storage
- `@Environment(\.modelContext)` provides context to views
- **CRUD operations via ModelContext:**
  - **Create:** `context.insert(newNote)`
  - **Read:** `@Query` macro with automatic updates
  - **Update:** Direct property modification on Note instance
  - **Delete:** `context.delete(note)`
- Manual save with error handling: `try context.save()` with catch block

### Query System

- `@Query` macro for reactive data fetching
- Automatic UI updates on data changes
- Sort descriptor: `@Query(sort: \Note.createdAt, order: .reverse)`
- Custom filtering logic in ViewModel layer via `search(for:from:)` function
- Type-safe queries with SwiftData integration

## State Management

- `@State` for local view state (note content, search text, keyboard focus, ViewModel instances)
- `@Environment(\.modelContext)` for SwiftData context
- `@Environment(\.dismiss)` for programmatic view dismissal
- `@Query` for reactive data binding to SwiftData
- `@AppStorage` for persistent user preferences via UserDefaults
  - `"isDarkOn"` - Dark mode preference (Bool)
  - `"scheme"` - Color scheme preference (ColorBackground enum)
- `@Model` macro for SwiftData model declaration
- `@Observable` macro for ViewModel observation
- `@MainActor` for main thread execution
- `@FocusState` for keyboard focus management
- State-based form validation with computed properties
- Automatic UI updates via SwiftData observation
- Direct `@AppStorage` binding in views (no centralized AppState)

## Key Features Explained

### Automatic Keyboard Focus

When opening Add or Update views:

- Keyboard automatically appears for immediate typing
- Implemented with `@FocusState` property wrapper
- `.focused($showKeyboard)` modifier on TextEditor
- `showKeyboard = true` set in `.onAppear`
- Provides seamless user experience
- No need to tap TextEditor first

### Search Functionality

- Real-time search across note content
- Case-insensitive, locale-aware matching via `localizedStandardContains`
- Animated search results with `.animation(.default, value: searchText)`
- Maintains sort order (newest first) during search
- Empty search shows all notes
- Search logic encapsulated in ViewModel for testability
- Uses function parameter injection: `search(for:from:)`

### Color Scheme Theming

Six beautiful color themes to personalize your experience:

- **Default (Gray):** Subtle gray tone (0.3 opacity) - raw value "default"
- **Blue:** Calm blue background (0.5 opacity)
- **Orange:** Warm orange tone (0.5 opacity)
- **Yellow:** Bright yellow background (0.5 opacity)
- **Green:** Fresh green tone (0.5 opacity)
- **Indigo:** Deep indigo background (0.5 opacity)

Theme persists across app launches via `@AppStorage("scheme")` and applies to all views.

### Dark Mode Support

- Toggle between light and dark mode in settings
- Preference persists via `@AppStorage("isDarkOn")`
- Applied at `NavigationStack` level in `NoteMainView`
- Propagates to all child views and navigation destinations automatically
- Dynamic label shows current mode
- Smooth transitions between modes

### Form Validation

Both add and edit screens include robust validation:

- Content cannot be empty or contain only whitespace
- Content is automatically trimmed before saving via `trimmedContent()`
- Save/Update button disabled when form is invalid
- Validation logic in ViewModel (`isNoteValid()`)
- Visual feedback through button state

### Clean UI Design

- Capsule-shaped list rows for modern look
- Hidden scroll backgrounds for custom theming
- Custom insets and spacing
- Smooth animations for search
- Consistent themed backgrounds across all views
- Gray-tinted row backgrounds and buttons

## Technologies

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's native persistence framework
- **MVVM Pattern** - Separation of concerns architecture
- **NavigationStack** - Type-safe hierarchical navigation
- **@Query** - Reactive data fetching from SwiftData
- **@Model** - SwiftData model declaration
- **@Observable** - Swift's observation system for ViewModels
- **@MainActor** - Main thread execution for UI code
- **ModelContext** - SwiftData context for CRUD operations
- **@AppStorage** - Persistent user preferences via UserDefaults
- **@FocusState** - Keyboard focus management
- **TextEditor** - Multi-line text input
- **SearchableModifier** - Built-in search functionality
- **Swipe Actions** - Gesture-based interactions
- **Picker** - Native selection controls for themes
- **Form** - SwiftUI form layout for settings

## Data Persistence

This application uses SwiftData for local data persistence:

- All notes are stored in a local SQLite database
- No backend server or network connection required
- Data persists across app launches and device restarts
- Automatic schema migration for model updates
- Reactive UI updates when data changes
- Type-safe queries with `@Query` macro
- User preferences (theme, dark mode) persist via UserDefaults with `@AppStorage`

## Requirements

- **iOS 26++**
- **Xcode 26+**
- **Swift 6**
- No internet connection required (fully offline)

## Getting Started

1. Open the project in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)
4. Start writing your notes!
