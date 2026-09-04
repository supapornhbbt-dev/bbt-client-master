#!/bin/zsh
# Deploy เว็บ BBT Client Master ขึ้น Cloudflare Pages (ใช้โทเคน Pages:Edit ที่ผู้ใช้สร้างไว้)
cd "$(dirname "$0")"
export CLOUDFLARE_API_TOKEN="$(head -c 200 ~/.bbt-cloudflare-token)"
export CLOUDFLARE_ACCOUNT_ID="dd24c9bdc45d339e00e111518eb2a578"
npx -y wrangler@latest pages deploy webapp --project-name=bbt-client-master --branch=main --commit-dirty=true
