# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

rails_env = ENV.fetch("RAILS_ENV", "development")

# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# to prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default is set to 3 threads as it's deemed a decent compromise between
# throughput and latency for the average Rails application.
#
# Any libraries that use a connection pool or another resource pool should
# be configured to provide at least as many connections as the number of
# threads. This includes Active Record's `pool` parameter in `database.yml`.
# Optimize thread count for better performance
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { 3 }
threads min_threads_count, max_threads_count

if rails_env == "production"
  # Optimize workers for production performance
  workers_count = Integer(ENV.fetch("WEB_CONCURRENCY") { 2 })
  workers workers_count if workers_count > 1

  preload_app!
  
  # Worker boot configuration for database connections
  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end
  
  # Better memory management
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end
end

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
environment rails_env

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

if rails_env == "development"
  # Specifies a very generous `worker_timeout` so that the worker
  # isn't killed by Puma when suspended by a debugger.
  worker_timeout 3600
end
