# RedeemIt


## Prerequisites

- Ruby 3.4.3
- Node.js 
- pnpm
- overmind

## Quick Setup

### Automated Setup Scripts

For the fastest setup, use the provided script:

**Development Environment:**
```bash
./scripts/setup-dev.sh
```

#### Start Both Servers

Use the provided script to start both backend and frontend:

```bash
./scripts/start-dev.sh
```

## Testing

### Quick Test Setup

Use the automated setup script:

```bash
./scripts/setup-test.sh
```

### Backend Tests

Run the full test suite:

```bash
# Run all tests
bundle exec rspec
```

### Test Database

The test database is automatically managed by RSpec:

```bash
# Reset test database
RAILS_ENV=test rails db:reset

# Run test migrations
RAILS_ENV=test rails db:migrate
```