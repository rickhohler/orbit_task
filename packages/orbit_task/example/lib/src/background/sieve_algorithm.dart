/// Performs the Sieve of Eratosthenes to find prime numbers up to [max].
///
/// Returns a list of all prime numbers found.
List<int> performSieve({int max = 10000}) {
  final List<bool> isPrime = List.filled(max + 1, true);
  isPrime[0] = false;
  isPrime[1] = false;

  for (int i = 2; i * i <= max; i++) {
    if (isPrime[i]) {
      for (int j = i * i; j <= max; j += i) {
        isPrime[j] = false;
      }
    }
  }

  // Use pattern matching or standard list manipulation to extract indices
  final primes = <int>[];
  for (int i = 0; i <= max; i++) {
    if (isPrime[i]) {
      primes.add(i);
    }
  }
  
  return primes;
}
