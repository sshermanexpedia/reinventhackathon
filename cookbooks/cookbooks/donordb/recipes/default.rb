include_recipe "s3cmd"

yum_package "postgresql-server" do
    action :install
end

yum_package "tomcat7" do
  action :install
end


directory "/var/lib/tomcat7/webapps/donorschoose" do
  owner "tomcat"
  group "tomcat"
  mode "755"
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

cookbook_file "/var/lib/pgsql9/data/pg_hba.conf" do
  source "pg_hba.conf"
  owner "postgres"
  group "postgres"
  mode "700"
end

execute "start_postgres " do
  command "service postgresql start"
end


script "Install webapp" do
  interpreter "bash"
  user "root"
  code  <<-EOH
  wget https://github.com/sshermanexpedia/reinventhackathon/raw/master/webapp/donorschoose.war
  EOH
end

script "unzip " do
  interpreter "bash"
  user "root"
  code  <<-EOH
  unzip donorschoose.war -d  /var/lib/tomcat7/webapps/donorschoose
  EOH
end
    
script "service restart " do
  interpreter "bash"
  user "root"
  code  <<-EOH
  service tomcat7 restart
  EOH
end

cookbook_file "/opt/donor/data/create_db.sql" do
  source "create_db.sql"
  owner "postgres"
  group "postgres"
  mode "700"
end

cookbook_file "/opt/donor/data/create_db.sh" do
  source "create_db.sh"
  owner "postgres"
  group "postgres"
  mode "700"
end

cookbook_file "/opt/donor/data/alter_user.sql" do
  source "alter_user.sql"
  owner "postgres"
  group "postgres"
  mode "700"
end

cookbook_file "/opt/donor/data/alter_user.sh" do
  source "alter_user.sh"
  owner "postgres"
  group "postgres"
  mode "700"
end

#execute "create-database-user" do
#  code = <<-EOH
#psql -U postgres -c "select * from pg_user where usename='#{node['donordb']['dbuser']}'" | grep -c #{node['donordb']['dbuser']}
#  EOH
#  command "ssh -t 'sudo -u createuser -sw #{node['donordb']['dbuser']}'"
#  not_if code
#end


#execute "create-database" do
#  exists = <<-EOH
#psql -U postgres -c "select * from pg_database WHERE datname='#{node['donordb']['dbname']}'" | grep -c #{node['donordb']['dbname']}
#  EOH
#  command "ssh -t 'sudo -u postgres createdb -O #{node['donordb']['dbuser']} -E utf8 -T template0 #{node['donordb']['dbname']}'"
#  not_if exists
#end
execute  "create_db" do
  command "sh create_db.sh"
  cwd "/opt/donor/data"
end

execute  "alter_user" do
  command "sh alter_user.sh"
  cwd "/opt/donor/data"
end

execute  "ingest" do
  command "sh ingest.sh"
  cwd "/opt/donor/data"
end




