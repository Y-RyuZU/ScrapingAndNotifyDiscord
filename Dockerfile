FROM mcr.microsoft.com/playwright:v1.49.1-noble

# 作業ディレクトリを設定
WORKDIR /app

# パッケージファイルをコピー
COPY package.json package-lock.json ./

# 必要な依存関係をインストール
RUN npm install --omit=dev

# アプリケーションコードを個別にコピー
COPY notify_on_change.js ./

# 必要なブラウザをインストール (Chromiumのみ)
RUN npx playwright install chromium

# コンテナの実行時コマンド
CMD ["node", "notify_on_change.js"]

