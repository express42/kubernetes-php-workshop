#!/bin/bash

set +a -x -o pipefail

echo "Installing Loki"
helm repo add loki https://grafana.github.io/loki/charts
helm repo update
helm upgrade --atomic --install loki loki/loki-stack --wait --timeout 600 \
    --namespace=monitoring \
    --version=0.15.0

echo "Installing Prometheus operator"
helm upgrade --atomic --install prometheus-operator stable/prometheus-operator --wait --timeout 600 \
    -f prometheus-operator-values.yaml \
    --namespace=monitoring \
    --version=6.2.0

echo "Setting up EFK stack"
helm repo add elastic https://helm.elastic.co
helm repo update

echo "Instaling Elasticsearch"
helm upgrade --atomic --install elasticsearch elastic/elasticsearch --wait --timeout 600 \
    -f elasticsearch-values.yaml \
    --namespace=logging \
    --version=7.3.0

echo "Installing Kibana"
helm upgrade --atomic --install kibana elastic/kibana --wait --timeout 600 \
    -f kibana-values.yaml \
    --namespace=logging \
    --version=7.3.0

echo "Installing Elastalert"
helm upgrade --atomic --install elastalert stable/elastalert --wait --timeout 600 \
    -f elastalert-values.yaml \
    --namespace=logging \
    --version=1.2.0

echo "Installing Elasticsearch Curator"
helm upgrade --atomic --install elasticsearch-curator stable/elasticsearch-curator --wait --timeout 600 \
    -f elasticsearch-curator-values.yaml \
    --namespace=logging \
    --version=2.0.0

echo "Installing Fluent Bit"
helm upgrade --atomic --install fluent-bit stable/fluent-bit --wait --timeout 600 \
    -f fluent-bit-values.yaml \
    --namespace=logging \
    --version=2.4.4

echo "Installing Elasticsearch Prometheus Exporter"
helm upgrade --atomic --install elasticsearch-exporter stable/elasticsearch-exporter --wait --timeout 600 \
    -f elasticsearch-exporter-values.yaml \
    --namespace=logging \
    --version=1.9.0
