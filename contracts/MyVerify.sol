pragma solidity ^0.4.18;
import "./Owned.sol";

contract MyVerify is Owned{

  function ecverify(bytes32 hash, bytes signature) public pure returns(address sig_address) {
    //署名したアドレスが返り値
    require(signature.length == 65);

    bytes32 r;
    bytes32 s;
    uint8 v;

    // The signature format is a compact form of:
    //   {bytes32 r}{bytes32 s}{uint8 v}
    // Compact means, uint8 is not padded to 32 bytes.
    assembly {
      r := mload(add(signature, 32))
      s := mload(add(signature, 64))

    // Here we are loading the last 32 bytes, including 31 bytes of 's'.
      v := byte(0, mload(add(signature, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible
    if (v < 27) {
      v += 27;
    }

    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedHash = keccak256(prefix, hash);

    require(v == 27 || v == 28);
    sig_address = ecrecover(prefixedHash, v, r, s);

    // ecrecover returns zero on error
    require(sig_address != 0x0);
    //return sig_address;
    //return(sig_address == _address);
  }
}