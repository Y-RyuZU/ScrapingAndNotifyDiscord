FROM mcr.microsoft.com/playwright:v1.39.0-focal

# 作業ディレクトリを設定
WORKDIR /app

# パッケージファイルをコピー
COPY package.json package-lock.json ./

# 必要な依存関係をインストール
RUN npm install --omit=dev

# アプリケーションコードをコピー
COPY . .

# 必要なブラウザをインストール
RUN npx playwright install chromium

# 環境変数を渡すために、エントリポイントをシェルスクリプト経由で設定
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
