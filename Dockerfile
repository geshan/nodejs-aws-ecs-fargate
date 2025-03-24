#buld stage
FROM public.ecr.aws/docker/library/node:22 AS build

WORKDIR /srv
COPY package*.json ./

# Install dependencies based on the `package.json` and `package-lock.json`
# files in the host folder
RUN npm ci --omit=dev


# Production stage, only includes what is needed for production
FROM public.ecr.aws/docker/library/node:22-alpine

ENV NODE_ENV=production
USER node

COPY --from=build /srv .
ADD . .

# Specify the command to run when launching the container
EXPOSE 80
CMD ["node", "index.js"]
