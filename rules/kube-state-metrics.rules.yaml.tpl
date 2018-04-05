groups:
- name: kube-state-metrics.rules
  rules:
  - alert: DeploymentGenerationMismatch
    expr: kube_deployment_status_observed_generation != kube_deployment_metadata_generation
    for: 15m
    labels:
      severity: warning
    annotations:
      description: Observed deployment generation does not match expected one for deployment {{ $labels.namespaces }}/{{ $labels.deployment }}
      summary: Deployment is outdated
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402325554/DeploymentGenerationMismatch"
  - alert: DeploymentReplicasNotUpdated
    expr: ((kube_deployment_status_replicas_updated != kube_deployment_spec_replicas)
      or (kube_deployment_status_replicas_available != kube_deployment_spec_replicas))
      unless (kube_deployment_spec_paused == 1)
    for: 15m
    labels:
      severity: warning
    annotations:
      description: Replicas are not updated and available for deployment {{ $labels.namespaces }}/{{ $labels.deployment }}
      summary: Deployment replicas are outdated
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/401899614/DeploymentReplicasNotUpdated"
  - alert: DaemonSetRolloutStuck
    expr: kube_daemonset_status_number_ready / kube_daemonset_status_desired_number_scheduled
      * 100 < 100
    for: 15m
    labels:
      severity: warning
    annotations:
      description: Only {{ $value }}% of desired pods scheduled and ready for daemon set {{ $labels.namespaces }}/{{ $labels.daemonset }}
      summary: DaemonSet is missing pods
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402489371/DaemonSetRolloutStuck"
  - alert: K8SDaemonSetsNotScheduled
    expr: kube_daemonset_status_desired_number_scheduled - kube_daemonset_status_current_number_scheduled
      > 0
    for: 10m
    labels:
      severity: warning
    annotations:
      description: A number of daemonsets are not scheduled.
      summary: Daemonsets are not scheduled correctly
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402489375/K8SDaemonSetsNotScheduled"
  - alert: DaemonSetsMissScheduled
    expr: kube_daemonset_status_number_misscheduled > 0
    for: 10m
    labels:
      severity: warning
    annotations:
      description: A number of daemonsets are running where they are not supposed
        to run.
      summary: Daemonsets are not scheduled correctly
      url: "https://transcore.jira.com/wiki/spaces/AD/pages/402685966/DaemonSetsMissScheduled"
