# syntax=docker/dockerfile:1
FROM node:20-alpine AS frontend
RUN apk add --no-cache git
ARG FRONTEND_REPOSITORY=https://github.com/ronak-jain-star/acme-salary-management-webui.git
ARG FRONTEND_REF=faa618febf2b5f31fa08321dc9e30eaa273e234d
RUN git clone ${FRONTEND_REPOSITORY} /frontend \
  && git -C /frontend checkout ${FRONTEND_REF} \
  && cd /frontend \
  && npm ci \
  && npm run build

FROM ruby:3.1.2-slim AS base
WORKDIR /rails
ENV RAILS_ENV=production BUNDLE_PATH=/usr/local/bundle BUNDLE_WITHOUT=development
RUN apt-get update -qq && apt-get install --no-install-recommends -y libpq5 curl && rm -rf /var/lib/apt/lists/*

FROM base AS build
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && rm -rf /var/lib/apt/lists/*
COPY Gemfile ./
RUN bundle install && rm -rf /usr/local/bundle/ruby/*/cache
COPY . .
COPY --from=frontend /frontend/dist ./public

FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails
RUN useradd rails --create-home --shell /bin/bash && chown -R rails:rails log tmp
USER rails:rails
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
