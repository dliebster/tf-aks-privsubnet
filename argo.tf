# resource "helm_release" "argocd" {
#   name             = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   namespace        = "argocd"
#   create_namespace = true
#   version          = "6.5.1"
#   values           = [file("./conf/argocd_helm.yaml")]
# }
# helm install argocd -n argocd -f values/argocd.yaml

data "kubectl_file_documents" "docs" {
    content = file("./conf/argocd.yaml")
}

resource "kubectl_manifest" "argocd_service" {
    yaml_body = file("./conf/argocd.yaml")
}