Task Management App – Take Home Assignment

Track Chosen:
I chose Track A: Full-Stack Builder
Frontend: Flutter (Dart)
Backend: FastAPI (Python)
Database: SQLite

Project Overview:
This is a Task Management application that allows users to create, view, update, and delete tasks with additional dependency handling between tasks.
Each task includes:
Title
Description
Due Date
Status (To-Do, In Progress, Done)
Blocked By (optional dependency on another task)
The application also visually and functionally enforces task dependencies.

Key Features Implemented:
CRUD Operations
Users can create, view, update, and delete tasks.
Backend APIs are built using FastAPI.
SQLite is used for persistent storage.
Blocked Task Logic
Tasks can depend on another task using "Blocked By".
If a task is blocked:
It appears visually greyed out.
User cannot change its status.
A message is shown indicating the dependency.
Draft Persistence
While creating a task, if the user navigates away, the entered data is preserved.
Implemented using Provider state (in-memory).
Loading State (2-second delay)
Simulated delay for create and update operations.
UI shows loading indicator and prevents duplicate actions.
Search Functionality
Users can search tasks by title.
Filter Functionality
Users can filter tasks based on status.

Stretch Feature Implemented:
Debounced Search
Implemented a 300ms debounce using Timer from dart:async.
Prevents unnecessary API calls on every keystroke.
API is triggered only after user stops typing.
Improves performance and user experience.

Architecture:
Backend:
FastAPI
SQLAlchemy for ORM
Clean separation of:
Models
Schemas
Routes
Database layer
Frontend:
Flutter with Provider for state management
Structured folders:
models/
providers/
services/
screens/
widgets/
Data Flow:
UI → Provider → Service → API → Database

AI Usage:
I used AI tools (ChatGPT) occasionally for:
Debugging errors
Understanding specific concepts (like debounce logic and Provider patterns)
Structuring some parts of the code
However:
The overall architecture, flow, and majority of implementation were written and understood by me.
I ensured all generated code was reviewed, modified, and integrated properly.

Challenges Faced:
Handling self-referencing task dependencies in database
Managing state between screens (draft persistence)
Implementing correct blocked-task behavior (UI + logic)
Avoiding excessive API calls during search

How to Run:
Backend:
Navigate to backend folder
Activate virtual environment
Run:
python -m uvicorn app.main:app --reload
Frontend:
Navigate to frontend/task_manager_app
Run:
flutter pub get
flutter run

Final Notes:
This project focuses on:
Clean architecture
Proper state management
Real-world feature handling
Maintainable and readable code
I prioritized correctness, usability, and clarity over unnecessary complexity.
