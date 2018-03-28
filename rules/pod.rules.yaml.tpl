groups:
- name: pod.rules
  rules:
  - alert: PodRestartigTooOften
    expr: rate(kube_pod_container_status_restarts_total[2h]) * 7200 > 1
    for: 1m
    labels:
      severity: page
    annotations:
      description: Pod {{`{{$labels.namespace}}`}}/{{`{{$labels.pod}}`}} restarting more than once times during last 2 hours
      summary: Pod restarting too often
  - alert: PodVolumeDiskFull
    expr: kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes * 100 > 90
    for: 5m
    labels:
      severity: critical
    annotations:
      description: "Pod Volume {{ $labels.exported_namespace }}/{{ $labels.persistentvolumeclaim }} is above 90% usage (current value is: {{ $value }})"
      summary: "{{ $labels.persistentvolumeclaim }}: Disk usage above threshold"
