
if $(which minikube > /dev/null); then
    eval $(minikube docker-env)
fi

mkreload() {
    eval $(minikube docker-env)
}

# Fork and clone a Kubernetes or kubernetes-sigs project, setting up correct OpenShift repository information
fork_and_clone() {
    kube=$1
    parts=(${(@s:/:)kube}) # Can't do array access directly on the split line
    repo=$parts[2] # zsh arrays are 1-based

    gh repo fork --clone --default-branch-only $kube
    cd $repo
    git remote rename upstream kube
    git remote add upstream git@github.com:openshift/${repo}.git
}
