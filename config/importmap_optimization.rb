# Optimize JavaScript loading for production
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Enable preloading for critical modules
    Rails.application.config.importmap.cache_sweepers << Rails.root.join("app/javascript")
    
    # Set aggressive caching headers for importmap
    Rails.application.config.importmap.cache_control = "public, max-age=31536000, immutable"
  end
end