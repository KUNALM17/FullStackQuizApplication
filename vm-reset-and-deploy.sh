#!/bin/bash

echo "🔥 COMPLETE VM RESET & FRESH DEPLOYMENT"
echo "========================================"
echo "⚠️  This will remove ALL Docker data and deploy fresh!"
echo "Proceeding in 5 seconds... Press Ctrl+C to cancel"
sleep 5

# Step 1: Complete cleanup
echo ""
echo "🧹 STEP 1: Complete Docker cleanup..."
./vm-complete-cleanup.sh

# Step 2: Fresh deployment
echo ""
echo "🚀 STEP 2: Fresh deployment..."
./vm-fresh-deploy.sh

echo ""
echo "🎉 COMPLETE! Your fresh application is ready!"
echo "🌐 Access at: http://34.0.14.17"
