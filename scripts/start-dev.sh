#!/bin/bash
# Start both API and frontend services using overmind

overmind start &

# Wait for services to start
sleep 3

# Open browser to localhost:3001
echo "🌐 Opening browser to http://localhost:3001"
if command -v open &> /dev/null; then
    # macOS
    open http://localhost:3001
elif command -v xdg-open &> /dev/null; then
    # Linux
    xdg-open http://localhost:3001
elif command -v start &> /dev/null; then
    # Windows
    start http://localhost:3001
else
    echo "Could not automatically open browser. Please visit http://localhost:3001"
fi

# Wait for overmind to finish
wait