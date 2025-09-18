
# Personal Finance Management App

🚀 **Live Demo**: [Deployed on Railway](https://mybe-production.up.railway.app)

## About This Fork

This is a personal fork of the Maybe Finance personal finance management application. This version includes:

- ✅ Deployed and running on Railway
- ✅ Updated dependencies and bug fixes
- ✅ Ready for self-hosting
- ✅ Full-featured personal finance tracking

## Features

- 📊 **Account Management**: Track all your financial accounts in one place
- 💰 **Transaction Tracking**: Automatic categorization and manual entry
- 📈 **Investment Portfolio**: Monitor your investment performance
- 🏠 **Real Estate**: Track property values and mortgage information
- 📱 **Modern UI**: Clean, responsive interface built with Rails and Tailwind CSS
- 🔒 **Privacy First**: Self-hosted solution - your data stays with you

## Quick Start

### Option 1: Try the Live Demo
Visit the [live demo](https://mybe-production.up.railway.app) to see the app in action.

### Option 2: Self-Host with Docker
The easiest way to self-host this application is using Docker. See the [Docker hosting guide](docs/hosting/docker.md) for detailed instructions.

### Option 3: Deploy to Railway
1. Fork this repository
2. Connect your Railway account to GitHub
3. Deploy directly from your fork
4. Configure environment variables as needed

## Technology Stack

- **Backend**: Ruby on Rails 7.2+
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **Database**: PostgreSQL
- **Cache**: Redis
- **Background Jobs**: Sidekiq
- **Deployment**: Railway (current), Docker-ready

## Local Development Setup

### Prerequisites

- Ruby 3.4.4 (see `.ruby-version` file)
- PostgreSQL 15+ 
- Redis 7+
- Node.js (for asset compilation)

### Setup Instructions

1. **Clone the repository**
   ```sh
   git clone https://github.com/diyaplayofficial-boop/maybe-finance-fork.git
   cd maybe-finance-fork
   ```

2. **Install dependencies**
   ```sh
   bundle install
   ```

3. **Setup environment**
   ```sh
   cp .env.local.example .env.local
   # Edit .env.local with your database credentials
   ```

4. **Setup database**
   ```sh
   bin/rails db:create db:migrate
   
   # Optionally, load demo data
   bin/rails db:seed
   rake demo_data:default
   ```

5. **Start the development server**
   ```sh
   bin/dev
   ```

6. **Visit the app**
   Open http://localhost:3000
   
   Default credentials:
   - Email: `user@maybe.local`
   - Password: `password`

## Contributing

This is a personal fork, but contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Environment Variables

Key environment variables for deployment:

```env
# Database
DATABASE_URL=postgresql://...

# Redis
REDIS_URL=redis://...

# Rails
RAILS_ENV=production
SECRET_KEY_BASE=your-secret-key

# Optional: External Services
PLAID_CLIENT_ID=your-plaid-id
PLAID_SECRET=your-plaid-secret
```

## Attribution & License

This project is a fork based on LedgerLeaf, which itself descends from Maybe Finance. This fork is maintained independently and includes various improvements and deployment optimizations.

- Original project: Maybe Finance
- Intermediate fork: LedgerLeaf
- This fork: Personal Finance Management App

Distributed under the [AGPLv3 license](LICENSE). This ensures the software remains open source.

### Trademark Notice
- "Maybe" and "Maybe Finance" are trademarks of Maybe Finance Inc.
- "LedgerLeaf" is a trademark of LedgerLeaf Labs, Inc.
- This fork does not claim any trademark rights and is an independent implementation.

---

⭐ **Star this repo if you find it helpful!**

🚀 **Live Demo**: https://mybe-production.up.railway.app
