global:
  resolve_timeout: 5m

route:
  group_by: ['job']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h
  receiver: 'slack_general'

receivers:
- name: slack_general
  slack_configs:
  - api_url: https://hooks.slack.com/services/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
    channel: '#jenkins'
