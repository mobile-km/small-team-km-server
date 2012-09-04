
# worker 数量
worker_processes 3

# 加载 超时设置 监听
preload_app true
timeout 60

stderr_path(File.expand_path('../../log/unicorn-error.log',__FILE__))
stdout_path(File.expand_path('../../log/unicorn.log',__FILE__))

listen File.expand_path('../../tmp/unicorn-teamkn.sock',__FILE__), :backlog => 2048

pid_file_name = File.expand_path('../../tmp/unicorn-teamkn.pid', __FILE__)
pid pid_file_name

# REE GC
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = pid_file_name + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # ...
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end