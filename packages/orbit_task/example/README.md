# OrbitTask Example

A robust demonstration of the `orbit_task` plugin ecosystem, showcasing advanced background task scheduling and execution.

## Features

- **Robust Scheduling**: Schedule one-time and recurring tasks with ease.
- **Constraints**: Apply network, charging, and battery constraints to tasks.
- **Heavy Processing**: Demonstrates background processing capabilities by executing the **Sieve of Eratosthenes** algorithm to calculate prime numbers up to 10,000.
- **Task Management**: Cancel specific tasks or wipe all scheduled tasks instantly.
- **Live Logging**: View real-time logs of scheduling actions and background execution results directly in the UI.

## Platform Setup

### Android
Uses `WorkManager` for reliable background execution.
- Added `WAKE_LOCK` and `RECEIVE_BOOT_COMPLETED` permissions.
- Configured purely via `AndroidManifest.xml`.

### iOS
Uses `BGTaskScheduler` for modern background processing.
- Configured `Info.plist` with `processing` and `fetch` background modes.
- Registered task identifiers: `simple_one_time`, `recurring_maintenance`, `complex_task`.

## Running the Example

1. **Initialize**: The app initializes `OrbitTask` on startup.
2. **Schedule**: Tap "One-Time (Simple)" to schedule a task that runs the Sieve of Eratosthenes.
3. **Observe**: Watch the Logs panel for the execution result (e.g., `[Background] Sieve Completed in 42ms. Found 1229 primes.`).
4. **Recurring**: Tap "Schedule Recurring" to set up a task that runs every 15 minutes (Android minimum).

## Architecture

This example demonstrates best practices for `orbit_task`:
- **Top-Level Dispatcher**: `backgroundDispatcher` is a `@pragma('vm:entry-point')` function executing independent of the UI.
- **Modular UI**: Widgets are broken down into `ControlPanel`, `StatusPanel`, and `LogPanel` for clean code separation.
- **Theming**: Features a custom "Orbit" Deep Purple & Neon theme.
