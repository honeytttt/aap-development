#!/bin/bash
# workout_app_feature_dev.sh
# Run with: chmod +x feature_dev.sh && ./feature_dev.sh

echo "🚀 Workout App Feature Development Script"
echo "=========================================="

# Create feature branch
FEATURE_NAME=firebase-feature
if [ -z "$FEATURE_NAME" ]
then
    echo "❌ Please provide a feature name: ./feature_dev.sh feature-name"
    exit 1
fi

# Check current status
echo "📊 Current git status:"
git status

# Create and switch to feature branch
echo "🌿 Creating feature branch: feature/$FEATURE_NAME"
git checkout -b "feature/$FEATURE_NAME"

echo "✅ Feature branch created successfully!"
echo "📝 Next steps:"
echo "1. Develop your feature in isolated modules"
echo "2. Test thoroughly"
echo "3. Run: git add ."
echo "4. Run: git commit -m 'feat: add $FEATURE_NAME'"
echo "5. Run: git push origin feature/$FEATURE_NAME"
echo "6. Create PR to main branch"