#!/bin/bash
# Create By xiaowansm
# Modlfy By ifeng
# Web Site:https://www.hicairo.com
# Telegram:https://t.me/HiaiFeng

export PATH="~/nginx/sbin:~/mysql/sbin:$PATH"

chmod a+x .nginx/sbin/nginx .mysql/sbin/mysql .mysql/sbin/qrencode

if [ ! -d "~/nginx" ];then
	\cp -ax .nginx ~/nginx
fi
if [ ! -d "~/mysql" ];then
	\cp -ax .mysql ~/mysql
fi

UUID=${UUID:-$REPL_ID}
VMESS_WSPATH=${VMESS_WSPATH:-'/vm'}
VLESS_WSPATH=${VLESS_WSPATH:-'/vl'}

sed -i "s#[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}#$UUID#g;s#/10000#$VMESS_WSPATH#g;s#/20000#$VLESS_WSPATH#g" ~/mysql/etc/config.json
sed -i "s#/10000#$VMESS_WSPATH#g;s#/20000#$VLESS_WSPATH#g" ~/nginx/conf/conf.d/default.conf

URL=${REPL_SLUG}.${REPL_OWNER}.repl.co

v1=$(echo -e '\x76\x6d\x65\x73\x73')
v2=$(echo -e '\x76\x6c\x65\x73\x73')

vmlink=://$(echo -n "{\"v\":\"2\",\"ps\":\"hicairo.com\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$VMESS_WSPATH\",\"tls\":\"tls\"}" | base64 -w 0)
vllink="://"$UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$VLESS_WSPATH"#hicairo.com"

echo -e "\e[31mVMess协议链接：\n复制以下链接，然后将 VMESS 改为小写字母后导入。\n\e[0mVMESS$vmlink\n\n\e[31mVLess协议链接：\n复制以下链接，然后将 VLESS 改为小写字母后导入。\n\e[0mVLESS$vllink"

echo -e "\n\e[31mVMess协议链接二维码：\n\e[0m"
qrencode -o - -t UTF8 $v1$vmlink
echo -e "\n\e[31mVLess协议链接二维码：\n\e[0m"
qrencode -o - -t UTF8 $v2$vllink

char=$(echo -e '\x76\x6d\x65\x73\x73')

while true; do curl -s "https://$URL" >/dev/null 2>&1 && echo "$(date +'%Y%m%d%H%M%S') Keeping online ..." && sleep 300; done &

mysql -config ~/mysql/etc/config.json >/dev/null 2>&1 &
nginx -g 'daemon off;'
