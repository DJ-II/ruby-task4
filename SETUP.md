# Task 4 – User Management (Ruby on Rails)

This is an overlay for a standard Rails 8.1 project, not a standalone Rails installation. Generate the base project first and copy all files from this package into it, replacing files where prompted.

## Windows / Visual Studio Code

1. Install Ruby 3.2+ and PostgreSQL, and create a PostgreSQL account able to create databases. Ruby 3.4 is supported.
2. Open PowerShell in VS Code.
3. Run:

```powershell
gem install rails -v 8.1.4
rails _8.1.4_ new ruby-task4 --database=postgresql --skip-solid
cd ruby-task4
```

4. Copy the *contents* of this ZIP into `ruby-task4`, preserving directory names and replacing conflicting files. Keep generated `bin/rails`, `config/boot.rb`, `config/application.rb`, `config/environments/*`, `config/credentials.yml.enc`, and all remaining Rails-generated files.
5. Set your PostgreSQL credentials in PowerShell, if your local server requires them:

```powershell
$env:PGUSER="postgres"
$env:PGPASSWORD="YOUR_LOCAL_POSTGRES_PASSWORD"
```

6. Run:

```powershell
bundle install
bundle lock --add-platform x86_64-linux
bundle exec rails db:create db:migrate
bundle exec rails test
bundle exec rails server
```

7. Open http://localhost:3000 and register a user.

## Important details

- Protected routes check account existence and blocked status on each HTTP request.
- Users blocked by another session stay on an already-open page until their next server request, when they are signed out.
- Registration permits a one-character password.
- The PostgreSQL UNIQUE expression index `index_users_on_lower_email` enforces case-insensitive uniqueness at the database level.
- There is no initial user data. Add only the users supplied by the assignment before final submission; no user list was provided with the supplied PDF.
- The PDF asks for extensive code comments containing “important”, “note” and “nota bene”; source code here intentionally has no comments per the developer's preference, so this portion of the assignment is not yet met.
- The complete specifications for any additional Task 4 chat stages were not provided in the uploaded PDF.

## Database index demonstration

Run in the local Rails console:

```powershell
bundle exec rails console
```

```ruby
ActiveRecord::Base.connection.indexes(:users).map { |index| [index.name, index.unique, index.columns] }
```

Or with PostgreSQL:

```sql
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'users';
```

## GitHub

Create an empty public repository (for example `DJ-II/ruby-task4`), then run:

```powershell
git add .
git commit -m "Implement user management application"
git branch -M main
git remote add origin https://github.com/DJ-II/ruby-task4.git
git push -u origin main
```

If the project folder has no `.git`, use `git init` first.

Never commit `config/master.key`, `.env` or other secrets. The standard Rails `.gitignore` should already exclude `config/master.key`.

## Render deployment

Create a PostgreSQL database under Render > New > Postgres, then create New > Web Service using the GitHub repo.

- Runtime: Ruby
- Build command: `bash bin/render-build.sh`
- Start command: `bundle exec rails server -b 0.0.0.0 -p $PORT`
- Environment variable `DATABASE_URL`: internal URL of the new database
- Environment variable `RAILS_MASTER_KEY`: contents of the local `config/master.key`
- Environment variable `RAILS_ENV`: `production`
- Environment variable `WEB_CONCURRENCY`: `2`
- Region: same as your database

On Free web instances, database migrations run from the build script because Render's pre-deploy command requires a paid plan.

A Free Render PostgreSQL instance expires 30 days after creation, so consider a longer-lived database if your submission must remain available for more than a month.

## Acceptance tests and demo recording

1. Register, confirm immediate access and success message.
2. Log out, log in, check sorted user list.
3. Select another user, block, confirm updated status.
4. Select them again, unblock, confirm updated status.
5. Select all, block including current user; expect redirect to login.
6. Open another browser/session to verify delayed invalidation on next request.
7. Test self-deletion and re-registration if it is part of your test plan.
8. Show PostgreSQL unique index, not just model validation.
9. Test on a mobile viewport.

Send full name, public repo link, deployed app link and a screen recording without narration to the recruiter address supplied for the assignment.
