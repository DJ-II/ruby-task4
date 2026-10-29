require "json"
require "securerandom"
require "time"

records = JSON.parse(File.read(Rails.root.join("db", "users.json")))
admin_email = ENV.fetch("SEED_ADMIN_EMAIL").strip.downcase
admin_password = ENV.fetch("SEED_ADMIN_PASSWORD")

raise "Expected exactly 200 users" unless records.is_a?(Array) && records.size == 200
raise "Admin password must not be empty" if admin_password.empty?

emails = records.map { |record| record.fetch("email").strip.downcase }
raise "Duplicate emails in JSON" unless emails.uniq.size == emails.size
raise "Invalid status" unless records.all? { |record| %w[active blocked].include?(record.fetch("status")) }
raise "Admin must be an active user from JSON" unless records.any? { |record| record.fetch("email").strip.downcase == admin_email && record.fetch("status") == "active" }

User.transaction do
  User.delete_all

  records.each do |record|
    email = record.fetch("email").strip.downcase

    User.create!(
      name: record.fetch("full_name"),
      email: email,
      job_position: record.fetch("job_position"),
      last_activity_at: Time.iso8601(record.fetch("last_seen")),
      blocked: record.fetch("status") == "blocked",
      password: email == admin_email ? admin_password : SecureRandom.urlsafe_base64(32)
    )
  end
end

puts "Imported #{User.count} users: #{User.where(blocked: false).count} active, #{User.where(blocked: true).count} blocked"
