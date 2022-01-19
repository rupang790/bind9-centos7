{{/*
Expand the name of the chart.
*/}}
{{- define "bind9-centos7.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bind9-centos7.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bind9-centos7.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bind9-centos7.labels" -}}
helm.sh/chart: {{ include "bind9-centos7.chart" . }}
{{ include "bind9-centos7.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bind9-centos7.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bind9-centos7.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bind9-centos7.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bind9-centos7.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the bind9 image
*/}}
{{- define "bind9-centos7.named.image" -}}
{{- $registryName := .Values.named.image.registry -}}
{{- $repositoryName := .Values.named.image.repository -}}
{{- $tag := .Values.named.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}

{{/*
Create the name of the client Pod image
*/}}
{{- define "bind9-centos7.clientPod.image" -}}
{{- $registryName := .Values.clientPod.image.registry -}}
{{- $repositoryName := .Values.clientPod.image.repository -}}
{{- $tag := .Values.clientPod.image.tag -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end }}
