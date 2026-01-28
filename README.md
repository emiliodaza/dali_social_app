# Social Platform Proposal (DALI Application Project)

This repository contains a **prototype and technical proposal** for a social platform built with Flutter and Firebase. It is submitted as part of an application and is intended to demonstrate how I approach system design, frontend–backend integration, and iterative development.

This is **not a finished product**. It is a work-in-progress prototype shared transparently for evaluation.

## Current State of the Prototype
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/5c0954ae-49e3-4e65-a1d9-5e7c38066f7d" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/7a020a87-82e3-434f-99f3-f1f5a11c120f" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/7f5d1cb5-1a58-445f-813b-00c657f6fcb8" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/20f4071d-6c97-4a06-a5ab-9a5f7c2bc24c" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/e579ef52-e9ae-4136-8cb0-d8a816e126b0" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/9ee800ba-b3d6-4591-a4e0-e4ad85a9a30e" />
<img width="1600" height="837" alt="image" src="https://github.com/user-attachments/assets/3568613a-f22d-4a2d-9582-a66f5aec8a2c" />

### Implemented and Working
- **User registration:** Fully functional.
- **User login:** Fully functional using email/password.
- **User discovery and search:** Users can search and browse other users.
- **User profiles:**  
  - Each user has an individual profile page.  
  - User data is correctly isolated per user.
- **Home view:**  
  - Displays cards for all users with associated profile data.

### Partially Implemented / Known Limitations
- **Claim-code authentication:**  
  - Registration and login work, but claim-code–based authentication is not yet supported.
- **UI overflow issues:**  
  - Some screens overflow on smaller viewports and require layout refinement.

### Not Yet Implemented
- **Chat / messaging:**  
  - Messaging functionality requires debugging.
- **Posting and feeds:**  
  - Post creation and feed interactions are not yet implemented.

## Technical Stack

**Frontend**
- Flutter (Web, Desktop, Mobile)
- Responsive UI (in progress)

**Backend / Cloud**
- Firebase Authentication
- Cloud Firestore (real-time data)
- Firebase Hosting (deployment explored, not finalized)

**Tooling**
- Git / GitHub
- Linux-based development workflow

- **UI state inconsistencies:**  
  - Some interactive elements (e.g., follow buttons) do not always reflect state changes immediately after user interaction, indicating areas where state management and UI updates need refinement.


## Running the Prototype Locally

```bash
flutter pub get
flutter run -d chrome
```

## AI Usage

I use AI tools as a productivity and learning aid, particularly during rapid prototyping and debugging. For this project, I used AI assistance to reason about Flutter layout constraints, Firebase integration patterns, and deployment workflows. I treat AI output as a starting point rather than a final solution: suggestions are validated against documentation, adapted to the codebase, and iterated on manually. This approach helped accelerate development while maintaining understanding of the system’s design and tradeoffs.

