#!/bin/bash

CONF_FILE="/etc/soga/soga.conf"
RESTART_CMD="soga restart"

# 定义要检查的配置项
required_lines=(
"dy_limit_enable=true"
"dy_limit_duration="
"dy_limit_trigger_time=60"
"dy_limit_trigger_speed=50"
"dy_limit_speed=20"
"dy_limit_time=600"
"dy_limit_white_user_id=1,11339"
)

# 检查文件是否存在
if [ ! -f "$CONF_FILE" ]; then
    echo "配置文件不存在: $CONF_FILE"
    exit 1
fi

# 标志变量：记录是否缺少配置
missing=false

# 检查每一行是否存在
for line in "${required_lines[@]}"; do
    if ! grep -q "^${line}$" "$CONF_FILE"; then
        missing=true
        break
    fi
done

if [ "$missing" = false ]; then
    echo "检测到已经存在限速配置"
else
    echo "没有检测到限速配置，正在添加缺失配置..."
    {
        echo ""
        echo "# 动态限速配置补充"
        for line in "${required_lines[@]}"; do
            echo "$line"
        done
    } >> "$CONF_FILE"

    echo "配置已添加，正在重启 soga..."
    $RESTART_CMD
fi
