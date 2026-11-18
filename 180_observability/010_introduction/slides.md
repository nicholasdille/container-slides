<i class="fa-duotone fa-solid fa-binoculars fa-4x"></i> <!-- .element: style="float: right;" -->

# Observability

---

> Observability is the ability to understand the internal state of a system based on its external outputs - IBM [](https://www.ibm.com/topics/observability) <!-- .element: style="text-align: right;" -->

---

## Why observability

<i class="fa-duotone fa-solid fa-lightbulb-on fa-4x"></i> <!-- .element: style="float: right;" -->

### Performance monitoring

Ensuring optimal system performance

### Capacity planning

Efficiently managing resources

### Fault detection and troubleshooting

Quickly identifying and resolving issues

### Security and compliance

Maintaining a secure and compliant environment

---

## What is Cloud Native

Approach that designs, builds, and operates applications to fully exploit the advantages of cloud computing

**Standardized** interfaces and practices

**Scalable** architecture

**Highly automated** operations

**Resilient** systems that can recover from failures

---

## Pillars of observability

- <i class="fa-duotone fa-solid fa-2x fa-chart-fft"></i><br/>**Metrics**<br/>Quantative data
- <i class="fa-duotone fa-solid fa-2x fa-file-lines"></i><br/>**Logs**<br/>Textual records of events
- <i class="fa-duotone fa-solid fa-2x fa-route"></i><br/>**Distributed Traces**<br/>Flow of a request<br/>through a system of services

<!-- .element: class="flex-columns" style="text-align: center;" -->

### An emerging fourth pillar

Profiling - function-level insights into application runtime behavior <i class="fa-duotone fa-solid fa-arrow-progress"></i>

---

## Metrics

<i class="fa-duotone fa-solid fa-chart-fft fa-4x"></i> <!-- .element: style="float: right;" -->

Numerical values that can be aggregated and visualized

Example: CPU usage, memory usage, request latency, error rate

### Purpose

**Resource management**: Ensure we have enough resources for applications

**Capacity planning**: Plan for scaling and resource allocation

**Troubleshooting**: Identify and resolve performance bottlenecks

**Cost optimization**: Optimize resource usage to reduce costs

**Service reliability**: Maintain high availability and performance of applications

**Autoscaling**:  Horizontal and Vertical Scaling requires metrics

---

## Logs

<i class="fa-duotone fa-solid fa-file-lines fa-4x"></i> <!-- .element: style="float: right;" -->

Timestamped textual records of events and activities

Crucial for diagnosing issues and monitoring system behavior

Example: User login events, API request logs, error messages

### Purpose

**Troubleshooting issues**: Identify and diagnose issues in your applications

**Audit trails**: Keep track of actions and changes for security and compliance

**Performance monitoring**: Analyze logs to detect performance bottlenecks

**User behavior analysis**: Understand how users interact with your application

---

## Distributed Traces

<i class="fa-duotone fa-solid fa-route fa-4x"></i> <!-- .element: style="float: right;" -->

Complex distributed systems have many components

Track the flow of a request

Each trace consists of a series of **spans**

Each span represents an individual operation

Spans are linked together to form a tree structure that represents the entire request flow

### Purpose

**Root cause analysis**: Identify where the request fails

**Performance monitoring**: Identify bottlenecks in request flow

---

## What is a trace?

![](180_observability/010_introduction/trace.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

A **trace** is single unit of work in a distributed system

A **span** is a single operation within a trace

All spans of a trace have the same context, e.g. a unique ID

The context is passed between spans

---

## Distributed Traces in Open Telemetry

[Open Telemetry](https://opentelemetry.io/) provides observability to your applications

Includes APIs, libraries, agents, and instrumentation

Vendor-neutral

Supports multiple backends (like Jaeger, Tempo etc.)

---

## Correlation

<i class="fa-duotone fa-solid fa-diagram-venn fa-4x"></i> <!-- .element: style="float: right;" -->

Anomaly in one signal

Check time range for other signals

### Example 1

High CPU load in a service <i class="fa-duotone fa-solid fa-arrow-right"></i> Access logs show high amount of requests

### Example 2

High latency of user requests <i class="fa-duotone fa-solid fa-arrow-right"></i> Traces help identify responsible component

---

## Sampling

<i class="fa-duotone fa-solid fa-eye-dropper-half fa-4x"></i> <!-- .element: style="float: right;" -->

Collecting only a subset of metrics, logs, and traces

Reduces the overhead of collecting and storing all data

Example: collect only error traces, drop specific labels, drop metrics with specific labels, scrape metrics every 30 seconds

### Suggestion

Do NOT collect data that you do not need

---

## Retention

<i class="fa-duotone fa-solid fa-broom-wide fa-4x"></i> <!-- .element: style="float: right;" -->

Removing outdated data

Reduces the overhead of storing all data

Example: historical metrics, quickly remove build logs

### Suggestion

Remove data that is no longer needed

This helps optimize storage and performance

---

![](180_observability/media/MediaWiki_flame_graph_screenshot_2014-12-15_22.png) <!-- .element: style="float: right; width: 35%;" -->

## Profiling

Considered the fourth pillar of observability

Think flame graphs

Provides code-level insight into application performance

Captures detailed stack traces to identify bottlenecks

### Out of scope for this workshop

<div style="float: right; font-size: 0.5em;">
(Source: <a href="https://en.wikipedia.org/wiki/File:MediaWiki_flame_graph_screenshot_2014-12-15_22.png">MediaWiki</a> flame graph screenshot)
</div>

---

## Comparison

Type      | Description                   | Purpose                   | Example                    |
----------|-------------------------------|---------------------------|----------------------------|
Metrics   | Quantative values             | State, trends             | Memory usage, latency      |
Logs      | Event-based, textual data     | Detailed analysis         | Error messages, debug info |
Traces    | Trace requests across systems | Performance, dependencies | Request state, correlation |
Profiling | Code-level performance data   | Identify code bottlenecks | Wasted CPU cycles          |
