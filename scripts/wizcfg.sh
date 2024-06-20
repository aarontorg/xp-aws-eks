#! /bin/zsh

# Simple script to update kubeconfig for all eks clusters

# shellcheck disable=SC2207
xk8s=( $(kubectl get xk8s | grep -v NAME | awk '{print $1}') )
declare -a xk8s
for x in "${xk8s[@]}" ;
do
  print "xk8: $x"
  xk8sUid=$(kubectl get xk8s $x -o jsonpath='{.metadata.uid}');
  print "xk8Uid: $xk8sUid"
  clusterName=$(kubectl get xk8s $x -o jsonpath='{.spec.id}')
  print "clusterName: $clusterName"
  secret=$(kubectl get secret -n crossplane-system | awk '{print $1}' | grep "${xk8sUid}-ekscluster")
  print "secretName: $secret"
  kubeconfig=$(kubectl get secret $secret -o=jsonpath='{.data.kubeconfig}' -n crossplane-system)
  echo "$kubeconfig" | base64 --decode > /Users/torg/.kube/$clusterName

done


