#!/bin/bash

echo "🧪 Testing Post Creation Workflow"
echo "================================="

echo "1. Starting Flutter app..."
echo "2. Check console for: 'FeedProvider initialized'"
echo "3. Look for: 'Loaded 3 mock posts'"
echo "4. Tap Create Post button (FAB or bottom nav)"
echo "5. Fill in post details"
echo "6. Submit post"
echo "7. Check console for: 'Adding new post:'"
echo "8. Verify: 'Post added successfully!' appears"
echo "9. New post should appear at TOP of feed"
echo "10. Total posts should now be 4"

echo ""
echo "🔄 If posts don't appear:"
echo "   - Check FeedProvider.addPost() is called"
echo "   - Verify notifyListeners() is called"
echo "   - Check navigation back to feed"
