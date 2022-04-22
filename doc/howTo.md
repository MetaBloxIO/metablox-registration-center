# How To

## 注册中心记录用户DID

mapping(string => address) public dids;

key为DID串，value为用户DID公钥


## 注册中心记录用户DID其他属性

DID的属性信息使用event来存储，如下所示：

```
event DIDAttributeChanged(
    string indexed did,
    bytes32 name,
    bytes value
  );
```

其中:
- did     DID串
- name    byte32格式，属性的名称
- value   属性的值

### 其他密钥

其他密钥现阶段暂不实现，考虑使用特定的key来存储其他密钥，如key-assertion-1表示assertion序号为1的key，value为pubkey。

### Services

service现阶段也不实现，key使用service-{序号}的形式，例如service-1。value为service内容，具体为json格式，如下

```
{
    "type":,      //service类型
    "serviceEndpoint":    //url地址
}
```

## 注册中心记录VC基础信息

### VC颁发者信息

mapping(string => string)  public vcIssuers; 

key 为VC名称，VC需要唯一，建议采用URL形式，例如中国科学技术大学颁发的毕业证，建议名称为"https://www.ustc.edu.cn/graduation_certificates"。该名称后续可以和每个证书的ID关联起来，例如中科大颁布的第100号毕业证，id为"https://www.ustc.edu.cn/graduation_certificates/100"

value 为颁发者DID信息

### VC基本信息

VC基本信息包括过期时间，凭证图片，吊销机制等，claims信息等，现阶段仅支持claims。基本信息使用event来存储，如下所示

```
 event VCSchemaChanged(
    string indexed vcName,  //vc名称
    bytes32  name,         
    bytes    value
  );
```

claims属性的存储格式为,
- name  "claims"
- value  json数组，表示vc支持的用户属性，如["id", "name", "graduate_time"]


## Nonce使用

每次调用合约的接口，需要使用DID用户自身的私钥签名。合约为了防止重放攻击，需要使用nonce值。每次发送合约接口之前需要先查询合约nonce值，在按合约接口检查数据的方式进行签名。密钥每验签成功一次，nonce值会自增。