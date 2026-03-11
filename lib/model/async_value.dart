sealed class AsyncValue<T> {
  const AsyncValue();
}

class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

class AsyncData<T> extends AsyncValue<T> {
  final T value;
  const AsyncData(this.value);
}

class AsyncError<T> extends AsyncValue<T> {
  final Object err;
  final StackTrace? stackTrace;
  const AsyncError(this.err, [this.stackTrace]);
}

// Optional: Add a convenient extension for pattern matching
extension AsyncValueExtension<T> on AsyncValue<T> {
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    return switch (this) {
      AsyncLoading() => loading(),
      AsyncData(:final value) => data(value),
      AsyncError(:final err, :final stackTrace) => error(err, stackTrace),
    };
  }
}
