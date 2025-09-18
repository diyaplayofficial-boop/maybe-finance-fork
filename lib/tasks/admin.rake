namespace :admin do
  desc "Create an admin user"
  task create: :environment do
    puts "Creating admin user..."
    
    email = ENV['ADMIN_EMAIL'] || ask("Enter admin email: ")
    password = ENV['ADMIN_PASSWORD'] || ask("Enter admin password: ")
    
    # Check if running in self-hosted mode
    unless Rails.application.config.app_mode.self_hosted?
      puts "This task is only for self-hosted deployments"
      exit 1
    end
    
    # Find or create a family
    family = Family.first || Family.create!(name: "Admin Family")
    
    # Create admin user
    user = User.find_or_initialize_by(email: email)
    user.assign_attributes(
      password: password,
      password_confirmation: password,
      family: family,
      role: "admin",
      first_name: "Admin",
      last_name: "User"
    )
    
    if user.save
      puts "✅ Admin user created successfully!"
      puts "Email: #{email}"
      puts "Role: admin"
    else
      puts "❌ Failed to create admin user:"
      puts user.errors.full_messages.join("\n")
    end
  end

  desc "Promote existing user to admin"
  task promote: :environment do
    email = ENV['USER_EMAIL'] || ask("Enter user email to promote: ")
    
    user = User.find_by(email: email)
    
    if user.nil?
      puts "❌ User with email #{email} not found"
      exit 1
    end
    
    if user.update(role: "admin")
      puts "✅ User #{email} promoted to admin successfully!"
    else
      puts "❌ Failed to promote user:"
      puts user.errors.full_messages.join("\n")
    end
  end

  desc "Generate invite codes"
  task generate_invites: :environment do
    count = (ENV['COUNT'] || ask("How many invite codes to generate? ")).to_i
    
    unless Rails.application.config.app_mode.self_hosted?
      puts "This task is only for self-hosted deployments"
      exit 1
    end
    
    unless Setting.require_invite_for_signup
      puts "⚠️  Warning: Invite codes are not required for signup. Enable this in Self-Hosting settings."
    end
    
    count.times do
      code = InviteCode.generate!
      puts "Generated invite code: #{code.token}"
    end
    
    puts "\n✅ Generated #{count} invite code(s)"
  end

  desc "List all invite codes"
  task list_invites: :environment do
    codes = InviteCode.all
    
    if codes.empty?
      puts "No invite codes found"
    else
      puts "\nInvite Codes:"
      puts "=" * 50
      codes.each do |code|
        status = code.used_by_user_id? ? "USED" : "AVAILABLE"
        puts "#{code.token} - #{status}"
        puts "  Created: #{code.created_at}"
        puts "  Used by: User ##{code.used_by_user_id}" if code.used_by_user_id?
        puts ""
      end
    end
  end

  private

  def ask(question)
    print question
    STDIN.gets.chomp
  end
end