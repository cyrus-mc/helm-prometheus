global:
  resolve_timeout: 5m
  slack_api_url: https://hooks.slack.com/services/
templates:
- '/etc/alertmanager/template/*.tmpl'

route:
  group_by: [ 'alertname', 'cluster' ]
  # how long to initially wait to send a notification
  # (allows for inhibiting alert to arrive)
  group_wait: 30s
  # how often to send notifications for this group
  group_interval: 5m
  # how long to wait before re-sending a given alert that
  # has already been sent
  repeat_interval: 5m
  receiver: default-receiver
  routes:
  - receiver: default-receiver
    group_by: [ 'service', 'deployment', 'namespace' ]
  - receiver: default-receiver
    group_by: [ 'service', 'statefulset', 'namespace' ]

inhibit_rules:
- source_match:
    severity: 'critical'
  target_match:
    severity: 'warning'
  equal: [ 'alertname', 'cluster', 'namespace'  ]

receivers:
- name: 'default-receiver'
  slack_configs:
  - channel: '#devops'
    title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] Prometheus Event Notification'
    text: >-
        {{ range .Alerts }}
           *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`
           *Description:* {{ .Annotations.description }}
           *Status:* `{{ .Status }}`
           *Details:*
           {{ range .Labels.SortedPairs }}  - {{ .Name }}: `{{ .Value }}`
           {{ end }}
        {{ end }}
    send_resolved: true

