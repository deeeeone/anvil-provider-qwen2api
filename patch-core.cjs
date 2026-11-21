// Adds account-token support to qwen2api's guest-only request path.
// Anvil passes the signed-in cookie as QWEN_TOKEN; without it the proxy stays in guest mode.
const fs = require('fs');
const file = process.argv[2] || 'core.js';
let s = fs.readFileSync(file, 'utf8');
if (s.includes('ANVIL_ACCOUNT_TOKEN')) { console.log('core.js already patched'); process.exit(0); }

const anchor = "const QWEN_GUEST_REFERER = `${QWEN_BASE_URL}/c/guest`;";
if (!s.includes(anchor)) throw new Error('core.js changed: guest referer line not found');
s = s.replace(anchor, anchor + "\nconst ANVIL_ACCOUNT_TOKEN = (typeof process !== 'undefined' && process.env && process.env.QWEN_TOKEN) || '';\nconst ANVIL_COOKIE = (cookies) => (ANVIL_ACCOUNT_TOKEN ? `token=${ANVIL_ACCOUNT_TOKEN}; ` : '') + cookies;\nconst ANVIL_CHAT_MODE = () => (ANVIL_ACCOUNT_TOKEN ? 'normal' : 'guest');\nconst ANVIL_REFERER = () => (ANVIL_ACCOUNT_TOKEN ? `${QWEN_BASE_URL}/c/new-chat` : QWEN_GUEST_REFERER);");

const before = s;
s = s.split("'Cookie': cookies,").join("'Cookie': ANVIL_COOKIE(cookies),");
s = s.split("chat_mode: 'guest'").join("chat_mode: ANVIL_CHAT_MODE()");
s = s.split("'Referer': QWEN_GUEST_REFERER").join("'Referer': ANVIL_REFERER()");
if (s === before) throw new Error('core.js changed: no request lines matched');
fs.writeFileSync(file, s);
console.log('core.js patched for account tokens');
