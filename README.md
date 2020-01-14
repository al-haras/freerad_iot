## Freeradius/Meraki iPSK Containers

This project came about as there was a need for IoT devices to be able to connect to a segregated network based on MAC address. This started as just a simple freeradius server that was containerized to help make the project more scalable and immutable.

This project uses freeradius: <https://freeradius.org>. The containers are built on ubuntu images. Initially, I was wanting to use the freeradius images, but they were not working for what I was wanting to accomplish. 

This is also built specifically to interface with Cisco Meraki equipment that allows for iPSK network authentication.

### Freeradius Configuration
To use the Dockerfile to make your images that you will be using, you will need to modify the `clients.conf` and `authorize` files to suit your needs. 

##### clients.conf
Clients.conf is used by freeradius to define where the connection requests are going to be coming from. An example of this is a hypothetical distribution center that has access points to allow devices to connect to a wireless network. `clients.conf` is for defining which ip address ranges the connection requests can come from. Additionally, you will define a password for these connections that will be shared with Meraki when setting up the SSID.

##### authorize
Authorize is used by freeradius to define which devices are able to connect. Here, you will define the devices by MAC address, the password they will use to connect, and the VLAN that you want them to connect to.

### Meraki Configuration
For Meraki, you will want to create a new SSID with the iPSK authentication type. If you are not given the option for iPSK, your Access Points will not support this. 

You will need to set the WPA encrpytion mode to WPA only. 802.11r and 802.11w should be disabled. For the RADIUS servers section you will add the IP address of the host and the port that you have the host forwarding to the docker container. The secret will be the password that you defined in clients.conf.

VLAN Tagging will need to be enabled, and VLAN ID should be set for the VLAN you want to specify. RADIUS override can be used if you want the RADIUS server to be able to override the VLAN tag defined here.

### Starting the Server
Be sure to have docker installed on the host. Before building the image, make the modifications you need to `clients.conf` and `authorize`. Assuming this is already do you will use docker to build the image:

`docker build . -f Dockerfile`

You can also modify the above command to include name and tag which is much easier to work with. This will build the image with your defined config files. You will also need to run the image.

`docker run -d -t -p $HOSTPORT:1812/udp $CONTAINER_NAME_OR_ID`

You will add the the server into Meraki with $HOSTPORT you set as the port that the RADIUS server will be on.

For additional servers you can just run the command and map the port to another available port on the host.