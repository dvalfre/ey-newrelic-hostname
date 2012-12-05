# hostname 
id = node['engineyard']['this']
role = node['instance_role'].gsub('_', ' ')
name = node['name']

hostname = "#{id} - #{role}"
hostname << " (#{name})" if name

# restart command
execute "nrsysmond-restart" do
  command "monit reload && sleep 2s && monit restart nrsysmond"
  action :nothing
end

# monit config
template "/etc/monit.d/nrsysmond.monitrc" do
  owner "root"
  group "root"
  mode 0644
  backup 0
  source "nrsysmond.monitrc.erb"
  variables({
    :hostname => hostname
  })
  notifies :run, resources(:execute => 'nrsysmond-restart'), :delayed
end