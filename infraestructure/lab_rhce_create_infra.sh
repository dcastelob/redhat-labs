#!/bin/bash

# https://www.cyberciti.biz/faq/how-to-install-kvm-on-centos-7-rhel-7-headless-server/

# https://www.linuxtechi.com/install-kvm-hypervisor-on-centos-7-and-rhel-7/

# Instalando componentes
yum install -y git wget
yum groupinstall -y "Virtualization Host"

yum install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install
yum install qemu-img virt-manager libvirt-client virt-viewer bridge-utils

# Checando se o KVM est[a habilitado
lsmod | grep -i kvm

# Habilitando o servicos
systemctl enable libvirtd
systemctl start libvirtd
systemctl status libvirtd

# A bridge default - Configuracao de rede
brctl show
virsh net-list

virsh net-dumpxml default

# Colocando o arquivo com a iso do Centos no path das imagens
cd /var/lib/libvirt/images/
export ISO_FILE="CentOS-7-x86_64-Minimal-1804.iso"
wget https://mirrors.edge.kernel.org/centos/7/isos/x86_64/"$ISO_FILE"


# Criacao de maquinas - Laboratorio RHCE

# Maquina servidora
virt-install \
--virt-type=kvm \
--name "Server-Centos7" \
--ram 2048 \
--vcpus=1 \
--os-variant=centos7.0 \
--cdrom=/var/lib/libvirt/images/"$ISO_FILE" \
--network=bridge=virbr0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/server-centos7.qcow2,size=40,bus=virtio,format=qcow2

# Maquina desktop
virt-install \
--virt-type=kvm \
--name "Desktop-Centos7" \
--ram 2048 \
--vcpus=1 \
--os-variant=centos7.0 \
--cdrom=/var/lib/libvirt/images/"$ISO_FILE" \
--network=bridge=virbr0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/desktop-centos7.qcow2,size=40,bus=virtio,format=qcow2

## Criando os snapshots padroes das maquinas

virsh snapshot-create-as \
--domain "Desktop-Centos7" \
--name "Inicial"

virsh snapshot-create-as \
--domain "Server-Centos7" \
--name "Inicial"

## adicionando suporte ao ntfs (hd-externo)
yum -y install epel-release 
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum install exfat-utils fuse-exfat ntfs-3g ntfsprogs 


