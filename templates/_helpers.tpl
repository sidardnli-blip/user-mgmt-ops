{{- define "user-mgmt-chart.fullname" -}}
{{ .Release.Name }}
{{- end -}}

{{- define "user-mgmt-chart.labels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}