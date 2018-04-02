groups:
- name: pod.rules
  rules:
  - alert: PodFrequentlyRestarting
    expr: increase(kube_pod_container_status_restarts_total[1h]) > 5
    for: 10m
    labels:
      severity: warning
    annotations:
      description: Pod {{ $labels.namespace }}/{{ $labels.pod }} was restarted {{ $value }} times within the last hour
      summary: "{{ labels.pod }} : is restarting frequently"
  - alert: PodVolumeDiskFull
    expr: kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes * 100 > 90
    for: 5m
    labels:
      severity: critical
    annotations:
      description: "Pod Volume {{ $labels.exported_namespace }}/{{ $labels.persistentvolumeclaim }} is above 90% usage (current value is: {{ $value }})"
      summary: "{{ $labels.persistentvolumeclaim }}: Disk usage above threshold"
  - alert: DeploymentReplicasUnavailable
    expr: kube_deployment_status_replicas - kube_deployment_status_replicas_available > 0
    for: 1m
    labels:
      severity: warning
    annotations:
      description: Deployment {{ $labels.deployment }} has {{ $value }} unavailable replicas
      summary: "{{ $labels.deployment }} : {{ $value }} replicas unavailable"
  - alert: DeploymentReplicasUnavailable
    expr: kube_deployment_status_replicas_available == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      description: Deployment {{ $labels.deployment }} has no available replicas
      summary: "{{ $labels.deployment }} : no replicas available"
  - alert: StatefulSetReplicasUnavailable
    expr: kube_statefulset_status_replicas - kube_statefulset_status_replicas_ready > 0
    for: 1m
    labels:
      severity: warning
    annotations:
      description: StatefulSet {{ $labels.statefulset }} has {{ $value }} unavailable replicas
      summary: "{{ $labels.statefulset }} : {{ $value }} replicas unavailable"
  - alert: StatefulSetReplicasUnavailable
    expr: kube_statefulset_status_replicas_ready == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      description: StatefulSet {{ $labels.statefulset }} has no available replicas
      summary: "{{ $labels.statefulset }} : no replicas available"
  - alert: K8SDaemonSetNotScheduled
    expr: kube_daemonset_status_desired_number_scheduled - kube_daemonset_status_current_number_scheduled > 0
    for: 10m
    labels:
      severity: warning
    annotations:
      description: DaemonSet {{ $labels.daemonset }} not fully scheduled
      summary: "{{ $labels.daemonset }} : not fully scheduled"
