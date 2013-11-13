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
end

execute  "import_data" do
  command "sh import_donor_data.sh"
  cwd "/opt/donor/data"
end