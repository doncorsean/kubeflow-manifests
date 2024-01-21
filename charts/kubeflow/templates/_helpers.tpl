{{/*
Expand the name of the chart.
*/}}
{{- define "kubeflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubeflow.fullname" -}}
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
{{- define "kubeflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubeflow.common.labels" -}}
helm.sh/chart: {{ include "kubeflow.chart" . }}
{{ include "kubeflow.common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "kubeflow.common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component specific labels
*/}}
{{- define "kubeflow.component.labels" -}}
{{ include "kubeflow.component.selectorLabels" . }}
{{- end }}

{{/*
Component specific selector labels
*/}}
{{- define "kubeflow.component.selectorLabels" -}}
app.kubernetes.io/component: {{ . }}
{{- end }}

{{/*
Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used

This gets around an problem within helm discussed here
https://github.com/helm/helm/issues/5358
{{- default .Values.namespace .Release.Namespace }}
*/}}
{{- define "kubeflow.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end -}}


{{- define "kubeflow.component.autoscaling.enabled" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- if eq nil $componentAutoscaling.enabled -}}
      {{- $defaultAutoscaling.enabled }}
  {{- else -}}
      {{- $componentAutoscaling.enabled }}
  {{- end -}}
{{- else -}}
  {{- $defaultAutoscaling.enabled }}
{{- end -}}
{{- end }}


{{- define "kubeflow.component.autoscaling.minReplicas" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.minReplicas $componentAutoscaling.minReplicas }}
{{- else -}}
  {{- $defaultAutoscaling.minReplicas }}
{{- end -}}
{{- end }}

{{- define "kubeflow.component.autoscaling.maxReplicas" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.maxReplicas $componentAutoscaling.maxReplicas }}
{{- else -}}
  {{- $defaultAutoscaling.maxReplicas }}
{{- end -}}
{{- end }}