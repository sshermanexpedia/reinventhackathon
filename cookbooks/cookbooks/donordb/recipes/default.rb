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

script "install_donor_data" do
  interpreter "bash"
  user "root"
  cwd "/opt/donor/data"
  code <<-EOH
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/04-open_data-projects.csv.gz
  tar -zxf 04-open_data-projects.csv.gz
  EOH
end

