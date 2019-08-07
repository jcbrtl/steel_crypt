//This Source Code Form is subject to the terms of the Mozilla Public
//License, v. 2.0. If a copy of the MPL was not distributed with this
//file, You can obtain one at https://mozilla.org/MPL/2.0/.

// © 2019 Aditya Kishore

part of 'steel_crypt_base.dart';

///General hashing class for usage
class HashCrypt {
  ///Type of algorithm
  static core.String type;

  ///Construct with type of algorithm
  HashCrypt ([core.String inType = 'SHA-3/512']) {
    type = inType;
  }

  ///hash with input
  core.String hash (core.String input) {
    var bytes = Base64Codec().decode(input);
    Digest digest;
    digest = Digest(type);
    var value = digest.process(bytes);
    return Base64Codec().encode(value);
  }

  ///HMAC hash with input and key
  core.String hashHMAC (core.String input, core.String key) {
    var listkey = Base64Codec().decode(key);
    var bytes = Base64Codec().decode(input);
    var params = KeyParameter(listkey);
    final _tmp = HMac(Digest(type), 128)..init(params);
    var val = _tmp.process(bytes);
    return Base64Codec().encode(val);
  }

  ///Check hashed against plain
  bool checkhash (core.String plain, core.String hashed) {
    var newhash = hash(plain);
    return newhash == hashed;
  }

  ///Check HMAC hashed against plain
  bool checkhashHMAC (core.String plain, core.String hashed, core.String key) {
    var newhash = hashHMAC(plain, key);
    return newhash == hashed;
  }
}
