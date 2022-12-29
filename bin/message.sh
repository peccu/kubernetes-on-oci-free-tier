#!/bin/bash
echo "# now you can use kubectl with these configurations"
echo "cat hosts-sample >> /etc/hosts"
echo "export KUBECONFIG=~/admin.conf"
echo "# or"
echo "mv ~/admin.conf ~/.kube/config"

