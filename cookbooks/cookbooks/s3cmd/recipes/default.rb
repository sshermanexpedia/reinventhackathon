template "/etc/yum.repos.d/s3tools.repo" do
    source "s3cmd.repo.erb"
    mode "644"
end

package "s3cmd"


template "/home/ec2-user/.s3cfg" do
    owner "ec2-user"
    group "ec2-user"
    mode "400"
#	variables(:s3_key_id=>s3['s3id'], :s3_key_secret=>s3['s3key'])
    source "s3cmd.config.erb"
end
