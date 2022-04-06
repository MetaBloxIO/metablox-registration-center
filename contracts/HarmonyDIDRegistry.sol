/* SPDX-License-Identifier: MIT */

pragma solidity ^0.8.13;

contract HarmonyDIDRegistry {

  mapping(string => address) public dids;
  /*
     key     credential  name
     value   issuer's did   
  */
  mapping(string => string)  public vcIssuers; 
  mapping(address => uint)   public nonce;

  event DIDAttributeChanged(
    string indexed did,
    bytes32 name,
    bytes value
  );

  event VCSchemaChanged(
    string indexed vcName,
    bytes32  name,
    bytes    value
  );
  
  function checkSignature(address owner, address pubkey, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) internal returns(address) {
    address signer = ecrecover(hash, sigV, sigR, sigS);
    if (owner == address(0x00)) {
      require(signer == owner, "bad_signature");
    } else {
      require(signer == pubkey, "bad_signature");
    }
    nonce[signer]++;
    return signer;
  }

  function registerOrUpdateDidKey(string memory did, address pubkey, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    address owner = dids[did];
    bytes32 hash = sha256(abi.encodePacked(did, pubkey, nonce[owner], "registerOrUpdate"));
    checkSignature(owner, pubkey, sigV, sigR, sigS, hash);
    dids[did] = pubkey;
  }

  function createVcDef(string memory name, string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(bytes(vcIssuers[name]).length == 0, "cred_exist");
    address owner = dids[did];
    bytes32 hash = sha256(abi.encodePacked(name, did, nonce[owner], "createVc"));
    checkSignature(owner, address(0x00), sigV, sigR, sigS, hash);
    vcIssuers[name] = did;
  }

  function setAttributeSigned(string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash = sha256(abi.encodePacked(nonce[owner], did, "setAttribute", name, value));

    checkSignature(owner, address(0x00), sigV, sigR, sigS, hash);

    emit DIDAttributeChanged(did, name, value);
  }

  function setVcAttributeSigned(string memory vcName, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    require(bytes(vcIssuers[vcName]).length != 0, "cred_not_exists");
    address owner = dids[vcIssuers[vcName]];
    bytes32 hash = sha256(abi.encodePacked(vcName, nonce[owner], "setVcAttribute", name, value));
    checkSignature(owner, address(0x00), sigV, sigR, sigS, hash);

    emit VCSchemaChanged(vcName, name, value);
  }

}
