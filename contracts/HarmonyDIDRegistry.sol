/* SPDX-License-Identifier: MIT */

pragma solidity >=0.4.22 <=0.8.13;

import "@openzeppelin/contracts/utils/Strings.sol";

contract HarmonyDIDRegistry {

mapping(string => address) public dids; //key: did string.  value: address
mapping(string => string)  public vcIssuers; //key:credential name. value: issuer's did 
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

  function checkSignature(address account, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 hash) internal {
    address signer = ecrecover(hash, sigV, sigR, sigS);
    require(signer == account, "bad_signature");
    nonce[signer]++;
  }

  function registerDid(string memory did, address account, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(dids[did] == address(0x00), "did_exist");

    bytes32 hash = keccak256(abi.encodePacked(did, account, Strings.toString(nonce[account]), "register"));
    bytes32 ethSignedMessageHash = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash
                )
    );
    checkSignature(account, sigV, sigR, sigS, ethSignedMessageHash);
    dids[did] = account;
  }

  function updateDid(string memory did, address account, uint8 nSigV, bytes32 nSigR, bytes32 nSigS, uint8 oSigV, bytes32 oSigR, bytes32 oSigS) public {
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash1 = keccak256(abi.encodePacked(Strings.toString(nonce[account]), did, "updateDid"));
    bytes32 ethSignedMessageHash1 = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash1
                )
    );
    checkSignature(owner, nSigV, nSigR, nSigS, ethSignedMessageHash1);
    
    bytes32 hash2 = keccak256(abi.encodePacked(ethSignedMessageHash1, Strings.toString(nonce[owner]), "updateDid"));
    bytes32 ethSignedMessageHash2 = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash2
                )
    );
    checkSignature(owner, oSigV, oSigR, oSigS, ethSignedMessageHash2);
    
    dids[did] = account;
  }

  function createVcDef(string memory name, string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    require(bytes(vcIssuers[name]).length == 0, "cred_exist");
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash = keccak256(abi.encodePacked(name, did, Strings.toString(nonce[owner]), "createVc"));
    bytes32 ethSignedMessageHash = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash
                )
    );
    checkSignature(owner, sigV, sigR, sigS, ethSignedMessageHash);
    vcIssuers[name] = did;
  }

  function setAttributeSigned(string memory did, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    address owner = dids[did];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash = keccak256(abi.encodePacked(Strings.toString(nonce[owner]), did, "setAttribute", name, value));
    bytes32 ethSignedMessageHash = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash
                )
    );

    checkSignature(owner, sigV, sigR, sigS, ethSignedMessageHash);

    emit DIDAttributeChanged(did, name, value);
  }

  function setVcAttributeSigned(string memory vcName, uint8 sigV, bytes32 sigR, bytes32 sigS, bytes32 name, bytes memory value) public {
    require(bytes(vcIssuers[vcName]).length != 0, "cred_not_exists");
    address owner = dids[vcIssuers[vcName]];
    require(owner != address(0x00), "did_not_exist");
    bytes32 hash = keccak256(abi.encodePacked(vcName, Strings.toString(nonce[owner]), "setVcAttribute", name, value));
    bytes32 ethSignedMessageHash = keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    hash
                )
    );
    checkSignature(owner,  sigV, sigR, sigS, ethSignedMessageHash);

    emit VCSchemaChanged(vcName, name, value);
  }
}