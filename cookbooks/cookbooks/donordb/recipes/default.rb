yum_package "postgresql-server" do
    action :install
end

yum_package "tomcat7" do
  action :install
end


