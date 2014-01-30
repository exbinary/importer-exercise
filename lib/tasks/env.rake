namespace :env do
  desc 'Initialize new keys in .env file'
  task :init do
    File.open(Rails.root.join('.env'), 'w') do |f|
      f.puts "SESSION_TOKEN=#{`rake secret`}"
      f.puts "DEVISE_KEY=#{`rake secret`}"
    end
    puts "Environment variables unique to this site generated in file: ./.env"
  end
end
