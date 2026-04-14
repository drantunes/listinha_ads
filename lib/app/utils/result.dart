sealed class Result<S, F> {
  const Result();

  factory Result.ok(S value) => Ok(value);
  factory Result.error(F value) => Err(value);
}

final class Ok<S, F> extends Result<S, F> {
  final S value;

  Ok(this.value);
}

final class Err<S, F> extends Result<S, F> {
  final F value;

  Err(this.value);
}
