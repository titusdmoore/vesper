# Vesper - The File Synchronization Service

## Overview
This project aims to build a file synchronization service that allows multiple computers to keep files in sync automatically. The service will detect file changes, communicate over a network, and transfer only necessary updates efficiently.

## Features
### Phase 1: Core Syncing Logic
- **File Change Detection:** Monitor filesystem for added, modified, or deleted files.
- **Networking:** Implement a server-client model for file synchronization.
- **Basic File Transfer:** Send updated files over TCP or UDP (haven't decided yet).

### Phase 2: Efficiency & Optimization
- **Delta Sync:** Transfer only modified parts of files instead of entire files.
- **Compression:** Reduce bandwidth usage by compressing file transfers.
- **Parallel Uploads/Downloads:** Improve performance by handling multiple files simultaneously.

### Phase 3: Conflict Resolution & Robustness
- **Conflict Handling:** Implement strategies like last-writer-wins, user prompts, or versioning.
- **Retries & Error Handling:** Ensure robustness against network failures.
- **Encryption:** Secure file transfers (optional, for later phases).

### Phase 4: User Interface & Polish
- **CLI or GUI Interface:** Allow users to manage sync settings.
- **Logging & Notifications:** Provide real-time feedback on sync status.

## Tech Stack
- **Filesystem Monitoring:** Odin standard library or OS-specific APIs (`inotify` on Linux, `FSEvents` on macOS, `ReadDirectoryChangesW` on Windows).
- **Networking:** TCP sockets or UDP.
- **Data Storage:** SQLite for file metadata or a simple log file.

## Getting Started
1. Implement a file watcher to detect changes.
2. Develop a basic networked file transfer mechanism.
3. Optimize with delta sync and compression.
4. Implement conflict resolution strategies.
5. Build a CLI or GUI for user interaction.

## Future Improvements
- **Peer-to-Peer (P2P) Syncing** instead of a centralized model.
- **Cross-platform Support** with OS-specific optimizations.
- **Advanced Security Features** like end-to-end encryption.
