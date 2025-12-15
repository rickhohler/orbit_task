# Changelog

All notable changes to this project will be documented in this file.

## [0.0.1+1] - 2025-12-15

### Added
- **Federated Plugin Structure**: Split into `orbit_task` (facade), `orbit_task_android`, `orbit_task_ios`, `orbit_task_web`, and `orbit_task_platform_interface`.
- **Android Support**:
    - Native `WorkManager` integration for persistent background execution.
    - Headless `FlutterEngine` initialization (`OrbitTaskWorker`) to run Dart code even when the app is terminated.
    - Support for One-Time and Recurring tasks.
- **iOS Support**:
    - Native `BGTaskScheduler` integration.
    - Headless runner logic (`OrbitTaskIosPlugin`) using `UserDefaults` to persist callback handles.
- **Web Support**:
    - Fallback `Timer`-based scheduling for active sessions.
- **Annotations**: Introduced `orbit_task_annotations` package with `@orbitTask`.
- **Generator**: Introduced `orbit_task_generator` skeleton.
- **Documentation**:
    - Comprehensive READMEs for all packages.
    - ROADMAP.md outlining Generation 1, 2, and 3.
    - LICENSE (MIT), SECURITY.md, and CODE_OF_CONDUCT.md.
