#!/bin/sh

# .envファイルが存在する場合、読み込む
if [ -f ".env" ]; then
  export $(cat .env | xargs)
fi

# アプリケーションを実行
node notify_on_change.js
