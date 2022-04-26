# VC Schemas

## 访问 Wi-Fi 网络证书

字段:

- type: 可选值 user,validator,fisher
  - user 普通用户，可以访问网络
  - validator 验证 Wi-Fi 网络正常工作
  - fisher 找到作恶的 Wi-Fi 矿工，暂不实现

## 矿机厂商证书

基金会颁发证书给通过认证的厂商。厂商颁发证书给自己生产的矿机。只有认证厂商生产的设备才被允许挖矿。

厂商证书字段:

- name 名称
- email email 地址
- address 代币账户地址

## 矿机证书

只有拥有厂商颁发的合法证书才可以参与挖矿，矿机证书的包含的字段为:

- name 厂商名称
- model 型号
- serial 序列号
