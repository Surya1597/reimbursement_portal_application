# README

Reimbursement Portal:
A Rails 7 application that lets employees submit expense reimbursement bills and gives admins a dashboard to manage users and approve/reject submissions. Built with import‑map, Turbo, Stimulus, and Bootstrap styling.

Features:
* Authentication – email/password login (sessions controller, has_secure_password in User using bcrypt gem).
* Employee dashboard – summary cards plus a filterable table of bills with review info (EmployeeController#reimbursement_dashboard).
* Bill submission – Bootstrap form with conditional “other reason” field (Bill model + BillController).
* Admin user management – full CRUD from a single page using modals; handles profile data and validations (UserController#index/create/update/destroy).
* Admin bill review – approve/reject actions, KPI cards, and details per bill (admin_bills_dashboard view).
* Bootstrap styling – import‑map based setup, navbar, flash alerts, modals, cards, etc.

GETTING STARTED

Prerequisites:
* Ruby 3.2+/Rails 7.2
* Bundler 2.6
* Postgres (default DB)

Setup:
* bundle install
* bin/rails db:create db:migrate
* bin/rails db:seed   # optional, add seed data
* bin/rails server
Visit http://localhost:3000/sessions/login to sign in. Create an admin user manually via the console or seeds to access /admin/users.

Key Commands:
* bin/rails db:migrate – apply migrations (bill/user/profile tables, other_reason column, etc.)
* bin/rails test – run test suite (if expanded)
* bin/rails console – inspect data, create initial admin
* bin/rails assets:precompile – precompile assets for production (Bootstrap via CDN + import-map JS)

Usage Notes:

* Employee profile is required before submitting bills.
* Admin user dashboard uses modals; validation errors re-open the appropriate modal automatically.
* Bill approvals capture reviewer and timestamp (reviewed_by, reviewed_at).
