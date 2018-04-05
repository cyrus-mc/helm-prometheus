groups:
- name: kubelet.rules
  rules:
  - alert: K8SNodeNotReady
    expr: kube_node_status_condition{condition="Ready",status="true"} == 0
    for: 1h
    labels:
      severity: warning
    annotations:
      description: The Kubelet on {{ $labels.node }} has not checked in with the API,
        or has set itself to NotReady, for more than an hour
      summary: Node status is NotReady
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402391121/K8SNodeNotReady"
  - alert: K8SManyNodesNotReady
    expr: count(kube_node_status_condition{condition="Ready",status="true"} == 0)
      > 1 and (count(kube_node_status_condition{condition="Ready",status="true"} ==
      0) / count(kube_node_status_condition{condition="Ready",status="true"})) > 0.2
    for: 1m
    labels:
      severity: critical
    annotations:
      description: '{{ $value }} Kubernetes nodes (more than 10% are in the NotReady
        state).'
      summary: Many Kubernetes nodes are Not Ready
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/401899620/K8SManyNodesNotReady"
  - alert: K8SKubeletDown
    expr: count(up{job="kubelet"} == 0) / count(up{job="kubelet"}) > 0.03
    for: 1h
    labels:
      severity: warning
    annotations:
      description: Prometheus failed to scrape {{ $value }}% of kubelets.
      summary: Many Kubelets cannot be scraped
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402325578/K8SKubeletDown"
  - alert: K8SKubeletDown
    expr: absent(up{job="kubelet"} == 1) or count(up{job="kubelet"} == 0) / count(up{job="kubelet"})
      > 0.1
    for: 1h
    labels:
      severity: critical
    annotations:
      description: Prometheus failed to scrape {{ $value }}% of kubelets, or all Kubelets
        have disappeared from service discovery.
      summary: Many Kubelets cannot be scraped
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402325578/K8SKubeletDown"
  - alert: K8SKubeletTooManyPods
    expr: kubelet_running_pod_count > 100
    labels:
      severity: warning
    annotations:
      description: Kubelet {{ $labels.instance }} is running {{ $value }} pods, close
        to the limit of 110
      summary: Kubelet is close to pod limit
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/401899633/K8SKubeletTooManyPods"
