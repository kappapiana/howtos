[Aboullaite Med](http://aboullaite.me)

::: {.content role="main"}
KVM/libvirt: Forward Ports to guests with Iptables {#kvmlibvirt-forward-ports-to-guests-with-iptables .post-title}
==================================================

::: {.section .post-meta}
by [Mohammed Aboullaite](/author/mohammed/) \| 2017-11-26
:::

::: {.section .post-content}
I\'ve been playing in the past few weeks with kvm/qemu and libvirt to
set up some VMs. If you\'ve been using libvirt before, you\'ll for sure
agree that [Libvirt](https://libvirt.org/) is particularly awesome when
it comes to managing virtual machines, their underlying storage and
networks. However, if you happen to use [NAT-ed
networking](http://wiki.libvirt.org/page/Networking) and want to allow
external access to services offered by your VMs, you've got to do some
manual work. In this post, I\'ll try to demystify the process of NAT
port forwarding to VMs.

### Assign static IP address to VM {#assignstaticipaddresstovm}

First, we need to list available networks. to do so, we use the
following command:

    $ virsh net-list
    Name                 State      Autostart     Persistent
    ----------------------------------------------------------
    default              active     yes           yes

To see the `default` network information:

        $ virsh net-dumpxml default
        <network>
        <name>default</name>
        <uuid>2ba36c4f-46c9-4767-a9fc-6808cf001a19</uuid>
        <forward mode='nat'>
            <nat>
            <port start='1024' end='65535'/>
            </nat>
        </forward>
        <bridge name='virbr0' stp='on' delay='0'/>
        <mac address='52:54:00:8e:b5:88'/>
        <domain name='default'/>
        <ip address='192.168.122.1' netmask='255.255.255.0'>
            <dhcp>
            <range start='192.168.122.120' end='192.168.122.254'/>
            </dhcp>
        </ip>
        </network>

Where it\'s clearly indicated that the DHCP range is between
192.168.122.120 and 192.168.122.254.

Now, The first step toward setting up a public IP to our VM, is to get
it MAC address. Again this is easy to achieve using `virsh` CLI:

      $ virsh dumpxml VM_NAME | grep -i '<mac'
        <mac address='52:54:00:e2:95:c6'/>

The last step is to edit the network config to add new VM config using
the following command:

     $ virsh net-edit default

and add this line after the `<range ...>` section:

    <host mac='52:54:00:e2:95:c6' name='VM_NAME' ip='192.168.122.43'/>

To make changes effective, we need to start DHCP service using:

    $ virsh net-destroy default
    $ virsh net-start default

------------------------------------------------------------------------

Restarting DHCP service should be enough, However in some cases you need
to restart the `libvirt-bin` service:

    $ virsh shutdown VM_NAME
    $ /etc/init.d/libvirt-bin restart
    $ virsh start VM_NAME
    $ ping -a 192.168.122.43

------------------------------------------------------------------------

### Configuring the Firewall to port forward {#configuringthefirewalltoportforward}

By default, guests that are connected via a virtual network with
`<forward mode='nat'/>` can make any outgoing network connection they
like. Incoming connections are allowed from the host, and from other
guests connected to the same libvirt network, but all other incoming
connections are blocked by iptables rules.\
If we would like to make a service that is on a guest behind a NATed
virtual network publicly available, we need to setup the necessary
iptables rules to forward incoming connections to the host on any given
port.

Let\'s suppose for example that we need to forward the forward incoming
connections to port 9867 on host machine to port 22 on guest machine.
below are the needed rules to achieve that:

        # connections from outside
        $ iptables -I FORWARD -o virbr0 -d  192.168.122.43 -j ACCEPT
        $ iptables -t nat -I PREROUTING -p tcp --dport 9867 -j DNAT --to 192.168.122.43:22

        # Masquerade local subnet
        $ iptables -I FORWARD -o virbr0 -d  192.168.122.43 -j ACCEPT
        $ iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
        $ iptables -A FORWARD -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        $ iptables -A FORWARD -i virbr0 -o eno1 -j ACCEPT
        $ iptables -A FORWARD -i virbr0 -o lo -j ACCEPT

where `virbr0` is the interface in `192.168.122.0/24` subnet and `eno1`
is interface with public IP address.

Now that we have set up port forwarding, we can save this to our
permanent rule set and load the rule set:

    $ service netfilter-persistent save
    $ service netfilter-persistent reload

Now, test that your VM is accessible through your firewall\'s public IP
address:

     $ ssh user@PUBLIC_IP -p 9867

This should work!
:::
:::

::: {.section .copyright}
[Aboullaite Med](http://aboullaite.me) © 2020
:::
