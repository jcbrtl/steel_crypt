//This Source Code Form is subject to the terms of the Mozilla Public
//License, v. 2.0. If a copy of the MPL was not distributed with this
//file, You can obtain one at https://mozilla.org/MPL/2.0/.

// © 2019 Aditya Kishore

part of 'steel_crypt_base.dart';

///Class containing Message Authentication codes
class MacCrypt {
  String key32;
  String algorithm = 'SHA-3/256';
  String type = 'HMAC';
  HMAC mac1;
  CMAC mac2;

  MacCrypt(String key, [String intype, String algo]) {
    key32 = key;
    algorithm = algo;
    type = intype;
    if (type == 'HMAC') {
      mac1 = HMAC(key, algo);
    } else if (type == 'CMAC') {
      mac2 = CMAC(key, algo);
    }
  }

  ///Process and hash string
  String process(String input) {
    if (type == "HMAC") {
      return mac1.process(input);
    } else if (type == 'CMAC') {
      return mac2.process(input);
    }
    return "";
  }

  ///Check if plaintext matches previously hashed text
  bool check(String plain, String processed) {
    if (type == 'HMAC') {
      return mac1.check(plain, processed);
    }
    return mac2.check(plain, processed);
  }
}

class HMAC {
  KeyParameter listkey;
  String algorithm;
  static List<String> pads = ['aWM'];

  HMAC(String key, [String algo = 'SHA-3/256']) {
    var inter = base64.decode(key);
    listkey = KeyParameter(inter);
    algorithm = algo;
  }

  String process(core.String input) {
    var bytes;
    if (input.length % 4 == 0) {
      bytes = Base64Codec().decode(input);
    } else {
      var advinput = input;
      advinput = input + pads[0];
      advinput = advinput.substring(0, advinput.length - advinput.length % 4);
      bytes = Base64Codec().decode(advinput);
    }
    final _tmp = HMac(Digest(algorithm), 128)..init(listkey);
    var val = _tmp.process(bytes);
    return base64.encode(val);
  }

  bool check(String plain, String processed) {
    var newhash = process(plain);
    return newhash == processed;
  }
}

class CMAC {
  KeyParameter listkey;
  static List<String> pads = ['Xcv'];
  String algorithm;

  CMAC(String key, [algo = 'cfb-64']) {
    var inter = base64.decode(key);
    listkey = KeyParameter(inter);
    algorithm = algo;
  }

  String process(core.String input) {
    var bytes;
    if (input.length % 4 == 0) {
      bytes = Base64Codec().decode(input);
    } else {
      var advinput = input;
      advinput = input + pads[0];
      advinput = advinput.substring(0, advinput.length - advinput.length % 4);
      bytes = Base64Codec().decode(advinput);
    }
    final _tmp = CMac(BlockCipher('AES/' + algorithm.toUpperCase()), 64)
      ..init(listkey);
    var val = _tmp.process(bytes);
    return base64.encode(val);
  }

  bool check(String plain, String processed) {
    var newhash = process(plain);
    return newhash == processed;
  }
}
