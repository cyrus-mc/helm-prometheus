groups:
- name: pod-restart.rules
  rules:
  - alert: PodRestartigTooOften
    expr: rate(kube_pod_container_status_restarts_total[2h]) * 7200 > 1
    for: 1m
    labels:
      severity: page
    annotations:
      description: Pod {{`{{$labels.namespace}}`}}/{{`{{$labels.pod}}`}} restarting more than once times during last 2 hours
      summary: Pod restarting too often
