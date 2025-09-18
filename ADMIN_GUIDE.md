# LedgerLeaf Admin Guide

## Security Updates Applied

The following security improvements have been implemented:

1. **Self-Hosting Settings** - Now restricted to admin users only
2. **Invite Codes Management** - Only admins can view and generate invite codes
3. **Email Confirmation Settings** - Only admins can toggle this requirement
4. **Navigation Menu** - Self-hosting option only visible to admin users

## How to Set Up Your Admin Account

### Method 1: Using Railway Run (Recommended)

```bash
# Promote your existing user to admin
railway run rails admin:promote USER_EMAIL=your-email@example.com

# Or create a new admin user
railway run rails admin:create ADMIN_EMAIL=admin@example.com ADMIN_PASSWORD=your-secure-password
```

### Method 2: Using Railway Shell

```bash
# Enter Railway shell
railway shell

# Then run the rake task
rails admin:promote USER_EMAIL=your-email@example.com
```

## Managing Invite Codes

### Generate Invite Codes (Admin Only)

```bash
# Generate 5 invite codes
railway run rails admin:generate_invites COUNT=5

# List all invite codes
railway run rails admin:list_invites
```

### Through the Web Interface (Admin Only)

1. Log in as an admin user
2. Go to Settings → Self-Hosting
3. Enable "Require invite code for signup"
4. Navigate to `/invite_codes` to manage codes

## User Roles

- **Member** (default): Regular user, can manage their own finances
- **Admin**: Can access Self-Hosting settings and manage invite codes
- **Super Admin**: Full system access (reserved for special cases)

## Important Security Notes

1. **First User**: Make sure to promote your account to admin immediately after deployment
2. **Invite Codes**: When enabled, ALL new users need an invite code
3. **Email Confirmation**: When enabled, users must verify their email address
4. **Data Cache Clear**: This is a destructive action that removes all cached financial data

## Troubleshooting

### Can't Access Self-Hosting Settings
- Ensure you're logged in as an admin user
- Run `railway run rails admin:promote USER_EMAIL=your-email@example.com`

### Invite Codes Not Working
- Check if "Require invite code for signup" is enabled in Self-Hosting settings
- Verify the code hasn't been used (check with `rails admin:list_invites`)

### Need to Reset Admin Password
```bash
railway run rails console
user = User.find_by(email: "admin@example.com")
user.update!(password: "new_password", password_confirmation: "new_password")
```

## Environment Variables

Make sure these are set in Railway:

- `SELF_HOSTED=true`
- `SECRET_KEY_BASE` (generate with `openssl rand -hex 64`)
- `GEMINI_API_KEY` (for AI features)
- Database and Redis URLs (automatically configured by Railway)

## Regular Maintenance

1. Regularly review and clean up unused invite codes
2. Monitor admin user list - keep it minimal
3. Review user registrations if invite codes are disabled
4. Keep backups of your database

## Support

For issues specific to self-hosting, check:
1. Railway logs: `railway logs`
2. Application status: `railway status`
3. Database connection: Ensure PostgreSQL and Redis are running