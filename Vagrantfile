Vagrant.configure("2") do |config|
	config.vm.box = 'ubuntu14.04'
	config.vm.box_url = ''
    	config.vm.define :wordpress do |wordpress|
		wordpress.vm.provider :virtualbox do |v|
			v.name = "wordpress.dev"
			v.customize ["modifyvm", :id, "--memory", "1024", "--cpus", 4]
		end
        	#wordpress.vm.network :public_network
		wordpress.vm.network :public_network, ip: "10.10.69.174"
		wordpress.vm.hostname = "wordpress.dev"
		wordpress.vm.provision :shell, :path => "bootstrap.sh"
	end
end
