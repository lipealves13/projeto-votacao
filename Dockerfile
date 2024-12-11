FROM node:18

WORKDIR /app

COPY . .

RUN cd backend && npm install onchainkit ethers express cors dotenv
RUN cd frontend && npm install axios web-vitals serve && npm run build
RUN cd blockchain && npm install && npx hardhat compile

EXPOSE 3000 3001

CMD ["sh", "-c", "cd /app/blockchain && npx hardhat node & cd /app/backend && node index.js & cd /app/frontend && npx serve -s build -l 3000"]
