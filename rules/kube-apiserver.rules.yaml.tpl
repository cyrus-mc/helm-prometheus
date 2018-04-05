groups:
- name: kube-apiserver.rules
  rules:
  - alert: K8SApiserverDown
    expr: absent(up{job="kube-apiserver"} == 1)
    for: 5m
    labels:
      severity: critical
    annotations:
      description: Prometheus failed to scrape API server(s), or all API servers have
        disappeared from service discovery.
      summary: API server unreachable
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402358312/K8SApiserverDown"
  - alert: K8SApiServerLatency
    expr: histogram_quantile(0.99, sum(apiserver_request_latencies_bucket{subresource!="log",verb!~"CONNECT|WATCHLIST|WATCH|PROXY"})
      WITHOUT (instance, resource)) / 1e+06 > 1
    for: 10m
    labels:
      severity: warning
    annotations:
      description: 99th percentile Latency for {{ $labels.verb }} requests to the
        kube-apiserver is higher than 1s.
      summary: Kubernetes apiserver latency is high
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/401932351/K8SApiServerLatency"
