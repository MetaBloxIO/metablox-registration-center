/* SPDX-License-Identifier: MIT */

pragma solidity >=0.4.22 <=0.8.13;

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

  function checkSignature(address _account, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) internal {
    address signer = ecrecover(hash, sigV, sigR, sigS);
    require(signer == _account, "bad_signature");
    nonce[signer]++;
  }

  function registerDid(string memory did, address _account, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(dids[did] == address(0x00), "did_exist");

    bytes32 hash = sha256(abi.encodePacked(did, _account, nonce[_account], "register"));
    bytes32 ethSignedMessageHash = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash
                )
    );
    checkSignature(_account, sigV, sigR, sigS, ethSignedMessageHash);
    dids[did] = _account;
  }

  function updateDid(string memory did, address pubkey, uint8 nSigV, bytes32 nSigR, bytes32 nSigS, uint8 oSigV, bytes32 oSigR, bytes32 oSigS) public {
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash1 = sha256(abi.encodePacked(nonce[pubkey], did, "updateDid"));
    checkSignature(owner, nSigV, nSigR, nSigS, hash1);
    
    bytes32 hash2 = sha256(abi.encodePacked(hash1, nonce[owner], "updateDid"));
    checkSignature(owner, oSigV, oSigR, oSigS, hash2);
    
    dids[did] = pubkey;
  } 

  function createVcDef(string memory name, string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(bytes(vcIssuers[name]).length == 0, "cred_exist");
    address owner = dids[did];
    bytes32 hash = sha256(abi.encodePacked(name, did, nonce[owner], "createVc"));
    checkSignature(owner, sigV, sigR, sigS, hash);
    vcIssuers[name] = did;
  }

  function setAttributeSigned(string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash = sha256(abi.encodePacked(nonce[owner], did, "setAttribute", name, value));

    checkSignature(owner, sigV, sigR, sigS, hash);

    emit DIDAttributeChanged(did, name, value);
  }

  function setVcAttributeSigned(string memory vcName, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    require(bytes(vcIssuers[vcName]).length != 0, "cred_not_exists");
    address owner = dids[vcIssuers[vcName]];
    bytes32 hash = sha256(abi.encodePacked(vcName, nonce[owner], "setVcAttribute", name, value));
    checkSignature(owner,  sigV, sigR, sigS, hash);

    emit VCSchemaChanged(vcName, name, value);
  }
}
