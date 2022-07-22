#!/bin/bash

LINK=订阅链接
mv ./config.yaml ./config.yaml.bak

curl -L -o config.yaml $LINK
CURLSTATUS=$?

chmod +x ./yq

# 修改配置
./yq -i '
  .port = 7890 |
  .allow-lan = true
' config.yaml
YQSTATUS=$?

if [ $CURLSTATUS -eq 0 ] || [ $YQSTATUS -eq 0 ]
then
  if cmp --silent -- "$DIRECTORY/config.yaml.bak" "$DIRECTORY/config.yaml"
  then
    echo "# $(TZ=Asia/Shanghai date)" >> config.yaml
    echo "Clash config updated successfully" "Nothing changed"
    rm ./config.yaml.bak
  else
    echo "# $(TZ=Asia/Shanghai date)" >> config.yaml
    echo "Clash config updated successfully" "File has changed"
    rm ./config.yaml.bak
  fi
else
  echo "Clash config updated failed" "cURL: $CURLSTATUS  yq: $YQSTATUS"
  rm ./config.yaml
  mv ./config.yaml.bak ./config.yaml
  touch ./config.yaml.bak
fi
