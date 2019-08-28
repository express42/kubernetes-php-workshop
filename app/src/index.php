<?php
require __DIR__ . '/vendor/autoload.php';
use Prometheus\CollectorRegistry;
use Prometheus\RenderTextFormat;
use Prometheus\Storage\InMemory;

include( './counter.php' ); 

$adapter = 'in-memory';
$adapter = new Prometheus\Storage\InMemory();

$registry = new CollectorRegistry($adapter);
$counter = $registry->registerCounter('hits', 'counter', 'it increases', ['type']);
$counter->incBy($count, ['hits']);

$registry = new CollectorRegistry($adapter);
$renderer = new RenderTextFormat();
$result = $renderer->render($registry->getMetricFamilySamples());
header('Content-type: ' . RenderTextFormat::MIME_TYPE);
echo $result
?>
