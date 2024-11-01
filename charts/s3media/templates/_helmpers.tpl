{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- $fullNameOverride := default "" .Values.fullnameOverride -}}
{{- if $fullNameOverride }}
{{- $fullNameOverride | trunc 63 | trimSuffix "-" | lower }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride | lower }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" | lower | replace "_" "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "selectorLabels" -}}
app.kubernetes.io/name: {{ include "name" . }}
app.kubernetes.io/instance: {{ .Release.Name | lower }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "labels" -}}
helm.sh/chart: {{ include "chart" . }}
{{ include "selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Generate a dockerconfigjson based on the given values
*/}}
{{- define "dockerconfigjson" -}}
{
  "auths": {
    "{{ .Values.image.imagePullSecrets.server }}": {
      "auth": "{{ printf "%s:%s" .Values.image.imagePullSecrets.username .Values.image.imagePullSecrets.password | b64enc }}"
    },
    "http://{{ .Values.image.imagePullSecrets.server }}": {
      "auth": "{{ printf "%s:%s" .Values.image.imagePullSecrets.username .Values.image.imagePullSecrets.password | b64enc }}"
    }
  }
}
{{- end }}