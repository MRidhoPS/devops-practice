# stages 1: builder
# alphine karna lebih ringan
FROM node:18-alpine AS builder
# semua command berikutnya akan jalan dari folder /app di dalam container 
WORKDIR /app
# copy file package.json & package-lock.json
COPY package*.json ./
# install semua dep
RUN npm install
# copy seluruh source code
COPY . .
# menjalankan command build yang mana nantinya akan menghasilkan .next
RUN npm run build

# Stage 2: production
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Ambil file dari stage builder
COPY --from=builder /app/package*.json ./
# install hanya dep production tanpa (devDep) hasilnya lebih ringan
RUN npm install --production

# copy hasil build dari stage builder dan static public sehingga tidak mengambil seluru source code
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
# container listen di port 3000
EXPOSE 3000
# jalankan nextjs di mode production
CMD ["npm", "start"]

# fungsi multi stage:
#     1. image lebih kecil
#     2. Lebih aman karena code build tidak terbawa ke runtime
#     3. lebih cepat deploy karena ukuruan image lebih kecil
