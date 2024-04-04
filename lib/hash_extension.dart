
// Add Hash functionality to our string id
import 'dart:convert';

import 'package:crypto/crypto.dart';

extension HashStringExtension on String{

    /// Return the SHA256 hash of this string.
   String get hashValue {
     return sha256.convert(utf8.encode(this)).toString();
   }
}
