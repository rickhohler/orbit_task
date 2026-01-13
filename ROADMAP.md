# OrbitTask Roadmap 🪐

This document outlines the strategic direction and planned evolution of the OrbitTask ecosystem.

## 🟢 Generation 1: Native Sovereignty (Current Focus)
**Goal:** Establish the most robust, battery-conscious, and reliable background task scheduler for Flutter applications running on the device itself.

### Core Objectives
- [x] **Federated Architecture**: Modularize codebase into `orbit_task`, `orbit_task_android`, `orbit_task_ios`, and `orbit_task_web`.
- [x] **Native Android Implementation**: Direct integration with `WorkManager` for guaranteed execution, boot survivability, and constraint handling.
- [x] **Native iOS Implementation**: Direct integration with `BGTaskScheduler` for efficient, system-compliant background processing.
- [x] **Web Support**: Timer-based fallback for standard web sessions.
- [ ] **Developer Experience**: 
  - [x] `@orbitTask` Annotation support.
    - [x] `orbit_task_generator` to automate `callbackDispatcher` boilerplate.
- [x] **Stability & Testing**: Comprehensive integration tests across real devices.

---

## 🔵 Generation 2: Orbit Link (The Distributed Horizon)
**Goal:** Transcend the device boundaries. Enable OrbitTask to seamlessly offload tasks to secure, remote servers via gRPC, effectively turning mobile devices into edge nodes of a larger distributed system.

### Vision
Developers shouldn't have to rewrite their task logic to move it from a local background job to a serverless function. OrbitTask will provide a unified interface where a task can be configured to run **locally** or **remotely** based on constraints or configuration.

### Planned Features
1.  **Secure gRPC Transport**:
    *   Implement a high-performance, bidirectional gRPC channel.
    *   Mutual TLS (mTLS) authentication for device-to-server security.
    *   Automatic retry and backoff policies for network instability.

2.  **Remote Task Execution**:
    *   Define tasks that execute on a remote "Orbit Server" rather than the local device.
    *   Automatic serialization of `inputData` and task context.
    *   "Local Fallback": If network is unavailable, optionally run the task locally.

3.  **Orbit Server (Headless Flutter Container)**:
    *   **Concept**: A containerized environment running a headless Flutter engine.
    *   **Execution**: Capable of executing the *exact same* Dart task code that runs on the mobile device, ensuring true "write once, run anywhere" logic sharing.
    *   **TBD**: Specific implementation details regarding the orchestrator and container lifecycle management are to be determined.

4.  **Integrated Monitoring**:
    *   Unified dashboard to view the status of local background tasks AND remote server tasks in one place.

### Why gRPC?
*   **Performance**: Protobuf serialization is significantly faster and smaller than JSON/REST.
*   **Streaming**: Allows for real-time progress updates from long-running server tasks back to the mobile device.
*   **Type Safety**: Strict contracts between the mobile client and the server.


