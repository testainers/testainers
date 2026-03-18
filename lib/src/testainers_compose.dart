import 'dart:io';

import 'package:testainers/src/testainers_config.dart';
import 'package:testainers/src/testainers_exception.dart';

/// Manages multi-container environments defined by a Docker Compose file.
///
/// [TestainersCompose] wraps the `docker compose` CLI to start, stop, and
/// interact with services declared in a `docker-compose.yml` (or equivalent)
/// file. It is designed for integration/system tests that require multiple
/// cooperating containers (e.g., an app server + database).
///
/// The class delegates all process execution to [TestainersConfig], so the
/// configured runner, timeout, and debug settings are respected.
///
/// Example:
/// ```dart
/// final compose = TestainersCompose(
///   composePath: 'docker-compose.test.yml',
/// );
///
/// await compose.up();
/// await compose.waitForHealth('http://localhost:3100/health');
///
/// // ... run tests ...
///
/// await compose.down(volumes: true);
/// ```
class TestainersCompose {
  /// Path to the Docker Compose file.
  ///
  /// Can be absolute or relative to the working directory.
  /// Passed as the `-f` argument to `docker compose`.
  final String composePath;

  /// Configuration for process execution (runner, timeout, debug).
  final TestainersConfig config;

  /// Optional project name for the Compose stack.
  ///
  /// If provided, passed as the `-p` argument to `docker compose`,
  /// isolating this stack from other Compose projects.
  /// If `null`, Docker Compose uses its default naming scheme.
  final String? projectName;

  /// Creates a [TestainersCompose] instance.
  ///
  /// - [composePath] — path to the `docker-compose.yml` file (required).
  /// - [config] — execution configuration. Defaults to [TestainersConfig]
  ///   with standard settings.
  /// - [projectName] — optional Compose project name for stack isolation.
  TestainersCompose({
    required this.composePath,
    this.config = const TestainersConfig(),
    this.projectName,
  });

  /// Builds the common prefix arguments for all `docker compose` commands.
  ///
  /// Returns `['compose', '-f', composePath]` with an optional
  /// `['-p', projectName]` segment when [projectName] is set.
  List<String> _composeArgs() {
    return <String>[
      'compose',
      '-f',
      composePath,
      if (projectName != null) ...<String>['-p', projectName!],
    ];
  }

  /// Starts all services defined in the Compose file in detached mode.
  ///
  /// Runs `docker compose -f <composePath> up -d`.
  ///
  /// Parameters:
  /// - [build] — if `true`, forces a rebuild of service images before
  ///   starting (`--build` flag). Defaults to `false`.
  ///
  /// Throws [TestainersException] if the command exits with a non-zero code.
  ///
  /// Example:
  /// ```dart
  /// await compose.up();          // start without rebuild
  /// await compose.up(build: true); // rebuild images first
  /// ```
  Future<void> up({bool build = false}) async {
    final List<String> arguments = <String>[
      ..._composeArgs(),
      'up',
      '-d',
      if (build) '--build',
    ];

    await config.exec(
      arguments: arguments,
      exceptionExec: 'Compose up failed for $composePath.',
    );
  }

  /// Stops and removes all containers, networks, and (optionally) volumes
  /// created by [up].
  ///
  /// Runs `docker compose -f <composePath> down`.
  ///
  /// Parameters:
  /// - [volumes] — if `true`, also removes named volumes declared in the
  ///   Compose file and anonymous volumes attached to containers
  ///   (`--volumes` flag). Defaults to `false`.
  ///
  /// Throws [TestainersException] if the command exits with a non-zero code.
  ///
  /// Example:
  /// ```dart
  /// await compose.down();               // keep volumes
  /// await compose.down(volumes: true);   // remove volumes too
  /// ```
  Future<void> down({bool volumes = false}) async {
    final List<String> arguments = <String>[
      ..._composeArgs(),
      'down',
      if (volumes) '--volumes',
    ];

    await config.exec(
      arguments: arguments,
      exceptionExec: 'Compose down failed for $composePath.',
    );
  }

  /// Executes a command inside a running Compose service container.
  ///
  /// Runs `docker compose -f <composePath> exec -T <service> <command...>`.
  /// The `-T` flag disables pseudo-TTY allocation, which is appropriate
  /// for non-interactive usage in tests and CI.
  ///
  /// Parameters:
  /// - [service] — the name of the service as defined in the Compose file
  ///   (e.g., `'web'`, `'db'`).
  /// - [command] — the command and its arguments to execute inside the
  ///   service container (e.g., `['rails', 'db:seed']`).
  /// - [env] — optional environment variables to set inside the container.
  ///   Each entry is passed as `-e KEY=VALUE` to `docker compose exec`.
  ///
  /// Returns the trimmed stdout output of the executed command.
  ///
  /// Throws [TestainersException] if the command exits with a non-zero code.
  ///
  /// Example:
  /// ```dart
  /// final tables = await compose.serviceExec(
  ///   'db',
  ///   ['psql', '-U', 'postgres', '-c', r'\dt'],
  /// );
  /// print(tables);
  ///
  /// // With environment variables:
  /// await compose.serviceExec(
  ///   'app',
  ///   ['bin/rails', 'db:reset'],
  ///   env: {'RAILS_ENV': 'test'},
  /// );
  /// ```
  Future<String> serviceExec(
    String service,
    List<String> command, {
    Map<String, String> env = const <String, String>{},
  }) async {
    final List<String> arguments = <String>[
      ..._composeArgs(),
      'exec',
      '-T',
      for (final MapEntry<String, String> e in env.entries)
        ...<String>['-e', '${e.key}=${e.value}'],
      service,
      ...command,
    ];

    return config.exec(
      arguments: arguments,
      exceptionExec: 'Exec failed in service $service for $composePath.',
    );
  }

  /// Polls an HTTP endpoint until it returns a 200 status code.
  ///
  /// Useful for waiting until a service inside the Compose stack is fully
  /// booted and ready to accept requests.
  ///
  /// Parameters:
  /// - [url] — the HTTP(S) URL to poll (e.g., `'http://localhost:3100/health'`).
  /// - [timeout] — maximum duration to keep retrying before giving up.
  ///   Defaults to 60 seconds.
  /// - [interval] — delay between successive poll attempts.
  ///   Defaults to 2 seconds.
  ///
  /// Returns `true` if the endpoint responded with HTTP 200 within the
  /// timeout window, `false` otherwise.
  ///
  /// This method never throws — connection errors and non-200 responses
  /// are silently retried until the timeout expires.
  ///
  /// Example:
  /// ```dart
  /// await compose.up();
  ///
  /// final ready = await compose.waitForHealth(
  ///   'http://localhost:3100/health',
  ///   timeout: const Duration(seconds: 90),
  /// );
  ///
  /// if (!ready) {
  ///   throw StateError('Backend did not become healthy');
  /// }
  /// ```
  Future<bool> waitForHealth(
    String url, {
    Duration timeout = const Duration(seconds: 60),
    Duration interval = const Duration(seconds: 2),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      try {
        final HttpClient client = HttpClient();

        try {
          final HttpClientRequest request = await client
              .getUrl(Uri.parse(url))
              .timeout(const Duration(seconds: 5));
          final HttpClientResponse response =
              await request.close().timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            return true;
          }
        } finally {
          client.close();
        }
      } on Exception {
        // Ignore and retry.
      }

      await Future<void>.delayed(interval);
    }

    return false;
  }
}
