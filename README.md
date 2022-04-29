# Registration Center

## Registr User DID

mapping(string => address) public dids;

key is DID string，value is user DID account

## Store other attributes of user did (service)

The attribute information of did is stored by event, as shown below:

```
event DIDAttributeChanged(
    string indexed did,
    bytes32 name,
    bytes value
  );
```

- did DID string
- name byte32, the name of the service
- value

### Other secret key

Other keys will not be implemented at this stage, 考虑使用特定的 key 来存储其他密钥，如 key-assertion-1 表示 assertion 序号为 1 的 key，value 为 pubkey。

### Services

Service will not be implemented at this stage，key 使用 service-{序号}的形式，例如 service-1。value 为 service 内容，具体为 json 格式，如下

```
{
    "type":,      //service type
    "serviceEndpoint":    //URL address
}
```

## Register basic information of VC

### The information of VC Issuer

mapping(string => string) public vcIssuers;

key is the name of VC, it is a unique key, URL format is recommended, For example, the graduation certificate issued by the University of science and technology of China, the recommended name is "https://www.ustc.edu.cn/graduation_certificates". This name is associated with the ID of each certificate, For example, the issuance of Graduation Certificate No. 100: "https://www.ustc.edu.cn/graduation_certificates/100"

value is the information of issuer did

### VC basic information

VC basic information includes expiration time, certificate image, revocation mechanism, claims information, etc. At this stage, only claims are supported. The basic information is stored using event, as shown below

```
 event VCSchemaChanged(
    string indexed vcName,  //vc名称
    bytes32  name,
    bytes    value
  );
```

The storage format of claims attribute is,

- name "claims"
- value JSON array,Indicates the user attributes supported by VC, for example ["id", "name", "graduate_time"]

## Nonce

Each time the API of the contract is called, the DID user's own private key signature is required. In order to prevent replay attacks, the nonce is also required. The nonce value will increase automatically every time the key is successfully verified.
