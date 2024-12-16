FROM mcr.microsoft.com/playwright:v1.49.1-noble

# 作業ディレクトリを設定
WORKDIR /app

# パッケージファイルをコピー
COPY package.json package-lock.json ./

# 必要な依存関係をインストール
RUN npm install --omit=dev

# アプリケーションコードを個別にコピー（.envを除外）
COPY notify_on_change.js ./
COPY entrypoint.sh /entrypoint.sh

# 必要なブラウザをインストール (Chromiumのみ)
RUN npx playwright install chromium

# エントリポイントスクリプトを実行可能に設定
RUN chmod +x /entrypoint.sh

# コンテナの実行時コマンド
CMD ["/entrypoint.sh"]

