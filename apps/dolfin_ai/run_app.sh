#!/bin/bash

# BalanceIQ App Runner Script
# This script helps you run the app with the correct configuration

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 BalanceIQ App Runner${NC}\n"

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file not found!${NC}"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo -e "${YELLOW}Please edit .env file with your configuration before running the app.${NC}"
    exit 1
fi

# Load environment variables from .env
export $(cat .env | grep -v '^#' | xargs)

# Check if N8N_WEBHOOK_URL is set
if [ -z "$N8N_WEBHOOK_URL" ] || [ "$N8N_WEBHOOK_URL" = "https://your-n8n-instance.com/webhook/balance-iq" ]; then
    echo -e "${RED}❌ N8N_WEBHOOK_URL is not configured!${NC}"
    echo "Please edit .env file and set your n8n webhook URL."
    exit 1
fi

echo -e "${GREEN}✓ Configuration loaded${NC}"
echo "N8N Webhook: $N8N_WEBHOOK_URL"
echo ""

# Run the app with dart defines
echo -e "${GREEN}Starting Flutter app...${NC}\n"
flutter run --dart-define=N8N_WEBHOOK_URL="$N8N_WEBHOOK_URL"
