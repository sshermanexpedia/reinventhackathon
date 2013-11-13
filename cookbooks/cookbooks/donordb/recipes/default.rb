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
  command "service postgresql initdb"
end


execute "start_postgres " do
  command "service postgresql start"
end


execute "create-database-user" do
  code = <<-EOH
psql -U postgres -c "select * from pg_user where usename='#{node['donordb']['dbuser']}'" | grep -c #{node['donordb']['dbuser']}
  EOH
  command "sudo  -u postgres createuser -sw #{node['donordb']['dbuser']}"
  not_if code
end


execute "create-database" do
  exists = <<-EOH
psql -U postgres -c "select * from pg_database WHERE datname='#{node['donordb']['dbname']}'" | grep -c #{node['donordb']['dbname']}
  EOH
  command "sudo -u postgres createdb -O #{node['donordb']['dbuser']} -E utf8 -T template0 #{node['donordb']['dbname']}"
  not_if exists
end


execute  "ingest" do
  command "sh ingest.sh"
  cwd "/opt/donor/data"
  not_if { File.exists?("/opt/donor/data/ingest.sql")}
end


execute "import_data" do
  command "sudo  -u postgres -d donorschoose -f /opt/donor/data/load-script.sql "
end

execute "Install webapp" do
  code = <<-EOH
    wget 'https://github.com/sshermanexpedia/reinventhackathon/raw/master/webapp/donorschoose.war' 
    mkdir /var/lib/tomcat7/webapps/donorschoose
    unzip donorschoose.war -d /var/lib/tomcat7/webapps/donorschoose
    service tomcat7 restart
  EOH
end

