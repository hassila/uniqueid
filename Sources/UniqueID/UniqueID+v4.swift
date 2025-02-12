// Copyright The swift-UniqueID Contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

extension UniqueID {

  /// Generates a new UUID with random bits from the system's random number generator.
  ///
  /// This function generates version 4 UUIDs, as defined by [RFC-4122][RFC-4122-UUIDv4].
  /// They are 128-bit identifiers, consisting of 122 random or pseudo-random bits, and are the most common form of UUIDs;
  /// for example, they are the ones Foundation's `UUID` type creates by default.
  ///
  /// [RFC-4122-UUIDv4]: https://datatracker.ietf.org/doc/html/rfc4122#section-4.4
  ///
  @inlinable
  public static func random() -> UniqueID {
    var rng = SystemRandomNumberGenerator()
    return random(using: &rng)
  }

  /// Generates a new UUID with random bits from the given random number generator.
  ///
  /// This function generates version 4 UUIDs, as defined by [RFC-4122][RFC-4122-UUIDv4].
  /// They are 128-bit identifiers, consisting of 122 random or pseudo-random bits, and are the most common form of UUIDs;
  /// for example, they are the ones Foundation's `UUID` type creates by default.
  ///
  /// [RFC-4122-UUIDv4]: https://datatracker.ietf.org/doc/html/rfc4122#section-4.4
  ///
  @inlinable
  public static func random<RNG>(using rng: inout RNG) -> UniqueID where RNG: RandomNumberGenerator {
    var randomBytes: (UInt64, UInt64) = (rng.next(), rng.next())
    return withUnsafeMutableBytes(of: &randomBytes) { bytes in
      // octet 6 = time_hi_and_version (high octet).
      // high 4 bits = version number.
      bytes[6] = (bytes[6] & 0xF) | 0x40
      // octet 8 = clock_seq_high_and_reserved.
      // high 2 bits = variant (10 = standard).
      bytes[8] = (bytes[8] & 0x3F) | 0x80
      return UniqueID(bytes: bytes.load(as: UniqueID.Bytes.self))
    }
  }
}
