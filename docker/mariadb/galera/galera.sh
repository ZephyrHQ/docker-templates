#!/bin/bash

function ownPublicIp()
{
    cat /docker-host
}

function isProd()
{
    [[ "$(ownPublicIp)" = "172.26.196.10" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.11" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.12" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.13" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.14" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.15" ]] && echo "true"
    [[ "$(ownPublicIp)" = "172.26.196.16" ]] && echo "true"
}

function isFirst()
{
    [[ "$(ownPublicIp | grep 172.26.196.10)" = "172.26.196.10" ]] && echo "true"
}

function isNew()
{
    [ -f "/var/lib/mysql/new" ] && echo "true"
}

function isCreated()
{
    [ -f "/var/lib/mysql/created" ] && echo "true"
}



function prepareHostsFile(){
    # copier le fichier hosts si il ne contient pas db1 dans /etc/hosts.base
    [[ "$(cat /etc/hosts | grep db1)" = "" ]] && cp /etc/hosts /etc/hosts.base
    # copier /etc/hosts.base sur /etc/host
    cp /etc/hosts.base /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.10" ]] || echo '127.0.0.1 db0' && echo '172.26.196.10 db0' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.11" ]] || echo '127.0.0.1 db1' && echo '172.26.196.11 db1' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.12" ]] || echo '127.0.0.1 db2' && echo '172.26.196.12 db2' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.13" ]] || echo '127.0.0.1 db3' && echo '172.26.196.13 db3' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.14" ]] || echo '127.0.0.1 db4' && echo '172.26.196.14 db4' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.15" ]] || echo '127.0.0.1 db5' && echo '172.26.196.15 db5' >> /etc/hosts
    [[ "$(ownPublicIp)" != "172.26.196.16" ]] || echo '127.0.0.1 db6' && echo '172.26.196.16 db6' >> /etc/hosts
}

function startNewCluster()
{
    echo "--wsrep-new-cluster"
}

function connectCluster()
{
    echo "--wsrep_cluster_address=$(getClusterAddress)"
}

function getClusterAddress()
{
    echo -n 'gcomm://'
    [[ "$(isNew)" = "172.26.196.10" ]] && return 
    #[[ "$(isCreated)" = "true" ]] && echo -n '172.26.196.10' && return 
    echo 'db0,db1,db2,db3,db4,db5,db6'

}

function updateMyCnf()
{
    echo ownPublicIp: $(ownPublicIp), getClusterAddress: $(getClusterAddress) 
    sed -i -e "s|#cluster1|wsrep_provider=/usr/lib/galera/libgalera_smm.so|" \
        -e "s|#cluster2|wsrep_cluster_name=terrabilis_cluster|" \
        -e "s|#cluster3|wsrep_sst_method=mysqldump|" \
        -e "s|#cluster4|wsrep_sst_auth=root:e444tG7P4vpBMk|" \
        -e "s|#cluster5|wsrep_sst_receive_address=$(ownPublicIp)|" \
        -e "s|#cluster6|wsrep_provider_options=$(wsrep_provider_options)|" \
        -e "s|#cluster7|wsrep_notify_cmd=bash /notify.sh|" \
        -e "s|#cluster8|wsrep_cluster_address=$(getClusterAddress)|" /etc/mysql/my.cnf
}

function wsrep_provider_options()
{
    echo -n "gcache.dir = /cache;"
    echo -n "gcache.page_size = 128M;"
    echo -n "gcache.size = 128M;"
    echo -n "base_host = $(ownPublicIp);"
    # avec ce réglage, il reconstruit a chaque fois la totalité de la bdd après 
    # chaque redémmarage, mais est au moins valable après un start (faux sinon)
    echo -n "ist.recv_addr = $(ownPublicIp);"
}

function galeraConf()
{
    [[ "$(isProd)" != "true" ]] && return "";
    prepareHostsFile
    updateMyCnf
}

function galeraOption()
{
    [[ "$(isNew)" != "true" ]] && connectCluster
    [[ "$(isNew)" = "true" ]] && startNewCluster
    echo ""
}
