#!/bin/sh
cd /app/blockchain && npx hardhat node &
cd /app/backend && node index.js &
cd /app/frontend && npx serve -s build -l 3000
