include_recipe "s3cmd"

yum_package "postgresql-server" do
    action :install
end

yum_package "tomcat7" do
  action :install
end

directory "/opt/donor" do
  owner "root"
  group "root"
  mode "755"
end

directory "/opt/donor/data" do
  owner "root"
  group "root"
  mode "755"
end


cookbook_file "/opt/donor/data/import_donor_data.sh" do
  source "import_donor_data.sh"
  owner "root"
  group "root"
  mode "700"
  not_if { File.exists?("/opt/donor/data/import_donor_data.sh")}
end

execute  "import_data" do
  command "sh import_donor_data.sh"
  cwd "/opt/donor/data"
  not_if { File.exists?("/opt/donor/data/import_donor_data.sh")}
end

cookbook_file "/opt/donor/data/ingest.sh" do
  source "ingest.sh"
  owner "root"
  group "root"
  mode "700"
  not_if { File.exists?("/opt/donor/data/ingest.sh")}
end

cookbook_file "/opt/donor/data/load-script.sql" do
  source "load-script.sql"
  owner "root"
  group "root"
  mode "700"
  not_if { File.exists?("/opt/donor/data/load-script.sql")}
end


execute "init_postgres " do
  command "service postgres initdb"
  action :nothing
end

execute "create-root-user" do
  code = <<-EOH
psql -U postgres -c "select * from pg_user where usename='root'" | grep -c root
  EOH
  command "sudo -u postgres createuser -s root"
  not_if code
end

execute "create-database-user" do
  code = <<-EOH
psql -U postgres -c "select * from pg_user where usename='#{node[:dbuser]}'" | grep -c #{node[:dbuser]}
  EOH
  command "sudo  -u postgres createuser -sw #{node[:dbuser]}"
  not_if code
end


execute "create-database" do
  exists = <<-EOH
psql -U postgres -c "select * from pg_database WHERE datname='#{node[:dbname]}'" | grep -c #{node[:dbname]}
  EOH
  command "sudo -u postgres createdb -O #{node[:dbuser]} -E utf8 -T template0 #{node[:dbname]}"
  not_if exists
end


execute  "ingest" do
  command "sh ingest.sh"
  cwd "/opt/donor/data"
end