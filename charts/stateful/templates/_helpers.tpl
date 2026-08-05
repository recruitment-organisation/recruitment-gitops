
{{- define "stateful.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "stateful.fullname" -}}
{{- default .Release.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}



{{- define "stateful.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "stateful.selectorLabels" -}}
app.kubernetes.io/name: {{ include "stateful.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}



{{- define "stateful.labels" -}}
helm.sh/chart: {{ include "stateful.chart" . }}
{{ include "stateful.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}


{{- define "stateful.configMapName" -}}
{{- printf "%s-config" (include "stateful.fullname" .) }}
{{- end }}



{{- define "stateful.secretName" -}}
{{- if .Values.secret.create }}
{{- printf "%s-secret" (include "stateful.fullname" .) }}
{{- else }}
{{- required "secret.existingSecret est obligatoire" .Values.secret.existingSecret }}
{{- end }}
{{- end }}


{{- define "stateful.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "stateful.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
