const { chromium } = require('playwright');
const axios = require('axios');

// 環境変数から取得
const DISCORD_WEBHOOK_URL = process.env.DISCORD_WEBHOOK_URL;
const TARGET_URL = process.env.TARGET_URL;
const SELECTOR = process.env.SELECTOR;

// Discord通知関数
async function sendDiscordNotification(message) {
    try {
        await axios.post(DISCORD_WEBHOOK_URL, {
            content: message,
        });
        console.log('Discordに通知を送信しました。');
    } catch (error) {
        console.error('Discord通知の送信中にエラーが発生しました:', error.message);
    }
}

// メイン処理関数
async function checkValueAndNotify() {
    const browser = await chromium.launch({ headless: true });
    const context = await browser.newContext();
    const page = await context.newPage();

    try {
        console.log('ターゲットURLにアクセスします...');
        await page.goto(TARGET_URL, { waitUntil: 'domcontentloaded' });

        console.log('必要な要素がレンダリングされるまで待機します...');
        await page.waitForSelector(SELECTOR, { timeout: 10000 });

        console.log('値を取得します...');
        const value = await page.locator(SELECTOR).innerText();

        // 数値を解析
        const numericValue = parseInt(value.replace(/\D/g, ''), 10);
        console.log(`取得した数値: ${numericValue}`);

        // 数値が0以外の場合に通知を送信
        if (numericValue > 0) {
            await sendDiscordNotification(`注意: 該当エレメントの数値が${numericValue}です。`);
        } else {
            console.log('数値は0のため通知をスキップします。');
        }
    } catch (error) {
        console.error('エラーが発生しました:', error.message);
    } finally {
        await browser.close();
    }
}

// プログラムを実行
checkValueAndNotify();
