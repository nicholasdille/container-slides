## Metrics

<i class="fa fa-sitemap fa-5x"></i><!-- .element: style="float: right;" -->

Performance indicators

### Host/process/container metrics

Easy to collect with generic agent

### Application metrics

Cloud native tools provide Prometheus metrics endpoint

Traditional tools require dedicated tooling

--

## Golden Signals

<i class="fa fa-traffic-light fa-5x"></i><!-- .element: style="float: right;" -->

[Google SRE](https://landing.google.com/sre/sre-book/toc/index.html) defines important signals to watch

### Latency

Latency of requests overall as well as per service

### Traffic

Demand placed on a service

### Errors

Rate of failed requests

### Saturation

Fraction of resources available to a service

--

## Visualization

<i class="fa fa-chart-area fa-5x"></i><!-- .element: style="float: right;" -->

Dashboard per service

Graphs for individual metrics

Only include useful metrics

One traffic light for each services

--

## Analysis

<i class="fa fa-binoculars fa-5x"></i><!-- .element: style="float: right;" -->

Service status depends on multiple metrics

Calculate service status from metrics and thresholds

Collect more metrics than required for RCA

### Statistics

Mean is problematic

95%/99% percentile

Develop baseline

Watch trends

--

## Alerting

<i class="fa fa-bell fa-5x"></i><!-- .element: style="float: right;" -->

Decide green/red or green/yellow/red

Make sure thresholds are reasonable

Only alert when intervention is unavoidable

Excess alerts lead to dulling lead to missed outages
