# VC Schemas

## 访问Wi-Fi网络证书

字段:
 * type:  可选值 user,validator,fisher
   - user 普通用户，可以访问网络
   - validator 验证Wi-Fi网络正常工作
   - fisher 找到作恶的Wi-Fi矿工，暂不实现

## 矿机厂商证书

只有认证的厂商才能生产矿机，厂商通过认证后会获得基金会颁发的证书。通过认证后厂商需要为自己颁发的矿机颁发证书。

厂商证书字段:

* name      名称
* email     email地址
* address   代币账户地址

## 矿机证书

只有拥有厂商颁发的合法证书才可以参与挖矿，矿机证书的包含的字段为:

* name    厂商名称
* model   型号
* serial  序列号
