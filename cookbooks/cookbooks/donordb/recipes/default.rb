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
  gunzip 04-open_data-projects.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/01-open_data-donations.csv.gz
  gunzip 01-open_data-donations.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/03-open_data-giftcards.csv.gz
  gunzip 03-open_data-giftcards.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/05-open_data-resources.csv.gz
  gunzip 05-open_data-resources.csv.gz
  wget https://s3-us-west-2.amazonaws.com/reinventhackathon/02-open_data-essays.csv.gz
  gunzip 02-open_data-essays.csv.gz
  EOH
end

