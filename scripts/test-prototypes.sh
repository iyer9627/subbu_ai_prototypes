#!/bin/bash

echo "🧪 Testing AI Prototypes"
echo "========================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:3001/api"

# Check if backend is running
echo "📡 Checking if backend is running..."
if curl -s "${BASE_URL}/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Backend is running${NC}"
else
    echo -e "${RED}✗ Backend is not running${NC}"
    echo "Please start the backend first:"
    echo "  npm run dev:backend"
    echo "  OR"
    echo "  docker-compose up backend"
    exit 1
fi

echo ""
echo "Testing prototypes..."
echo ""

# Test 1: Code Reviewer
echo "1️⃣  Testing Code Reviewer..."
RESPONSE=$(curl -s -X POST "${BASE_URL}/prototypes/code-reviewer/review" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function add(a, b) { return a + b; }",
    "language": "javascript"
  }')

if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✓ Code Reviewer is working${NC}"
else
    echo -e "${RED}✗ Code Reviewer failed${NC}"
    echo "Response: $RESPONSE"
fi

echo ""

# Test 2: Summarizer
echo "2️⃣  Testing Text Summarizer..."
RESPONSE=$(curl -s -X POST "${BASE_URL}/prototypes/summarizer/summarize" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Artificial intelligence (AI) is intelligence demonstrated by machines, in contrast to the natural intelligence displayed by humans and animals. Leading AI textbooks define the field as the study of intelligent agents: any device that perceives its environment and takes actions that maximize its chance of successfully achieving its goals.",
    "length": "short"
  }')

if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✓ Summarizer is working${NC}"
else
    echo -e "${RED}✗ Summarizer failed${NC}"
    echo "Response: $RESPONSE"
fi

echo ""

# Test 3: Interview Practice
echo "3️⃣  Testing Interview Practice..."
RESPONSE=$(curl -s -X POST "${BASE_URL}/prototypes/interview-practice/generate-questions" \
  -H "Content-Type: application/json" \
  -d '{
    "jobRole": "Software Engineer",
    "difficulty": "medium",
    "numberOfQuestions": 3
  }')

if echo "$RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✓ Interview Practice is working${NC}"
else
    echo -e "${RED}✗ Interview Practice failed${NC}"
    echo "Response: $RESPONSE"
fi

echo ""
echo "========================"
echo -e "${GREEN}✅ All tests completed!${NC}"
echo ""
echo "💡 Tips:"
echo "  - View detailed responses by adding | jq to the curl commands"
echo "  - Check backend logs for more information"
echo "  - See QUICKSTART.md for more examples"
echo ""
