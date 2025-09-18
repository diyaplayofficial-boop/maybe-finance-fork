# Assets optimization for production performance

if Rails.env.production?
  # Enable gzip compression for all responses
  Rails.application.config.middleware.use Rack::Deflater
  
  # Set longer cache headers for static assets
  Rails.application.config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=31536000',
    'Expires' => 1.year.from_now.to_formatted_s(:rfc822)
  }
  
  # Optimize asset compilation
  Rails.application.config.assets.css_compressor = :sass
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.digest = true
  
  # Precompile additional assets if needed
  Rails.application.config.assets.precompile += %w[
    application.js
    application.css
  ]
end