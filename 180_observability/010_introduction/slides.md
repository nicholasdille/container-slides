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

## Pillars of observability

<i class="fa-duotone fa-solid fa-tally-3 fa-4x"></i> <!-- .element: style="float: right;" -->

Metrics - quantative data <i class="fa-duotone fa-solid fa-chart-fft"></i>

Logs - textual records of events <i class="fa-duotone fa-solid fa-file-lines"></i>

Traces - flow of a request through a system of services <i class="fa-duotone fa-solid fa-route"></i>

(Profiling - function-level insights into application runtime behavior <i class="fa-duotone fa-solid fa-arrow-progress"></i>)

---

## Metrics

<i class="fa-duotone fa-solid fa-chart-fft fa-4x"></i> <!-- .element: style="float: right;" -->

Numerical values that can be aggregated and visualized

For example, CPU usage, memory usage, request latency, error rate

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

### Purpose

**Troubleshooting issues**: Identify and diagnose issues in your applications

**Audit trails**: Keep track of actions and changes for security and compliance

**Performance monitoring**: Analyze logs to detect performance bottlenecks

**User behavior analysis**: Understand how users interact with your application

---

## Traces

<i class="fa-duotone fa-solid fa-route fa-4x"></i> <!-- .element: style="float: right;" -->

Track the flow of a request

Each trace consists of a series of **spans**

Each span represents an individual operation

Spans are linked together to form a tree structure that represents the entire request flow

### Purpose

XXX

---

## Traces

Complex distributed systems have many components

**Tracing** is a method to track requests as they flow

It helps to identify, e.g. :
- Slow requests
- Bottlenecks
- Errors
- Performance issues

---

## What is a trace?

A **trace** is single unit of work in a distributed system

A **span** is a single operation within a trace

![](slides/09-monitoring/traces.drawio.svg) <!-- .element: style="width: 90%;" -->

All spans of a trace have the same context, e.g. a unique ID

The context is passed between spans

---

## Traces: Open Telemetry

![](slides/09-monitoring/otel.svg) <!-- .element: style="float: right; width: 10%;" -->

[Open Telemetry](https://opentelemetry.io/) provides observability to your applications

It includes APIs, libraries, agents, and instrumentation

It provides a single set of APIs and libraries to capture distributed traces and metrics from your applications

It is vendor-neutral and supports multiple backends like Jaeger, Tempo, etc.

---

## Correlation

<i class="fa-duotone fa-solid fa-diagram-venn fa-4x"></i> <!-- .element: style="float: right;" -->

Notice anomaly in one signal

Check time range for other signals

### Example 1

High CPU load in a service <i class="fa-duotone fa-solid fa-arrow-right"></i> Logs show abnormal behaviour

### Example 2

High latency of user requests <i class="fa-duotone fa-solid fa-arrow-right"></i> Traces help identify responsible component

---

## Sampling

<i class="fa-duotone fa-solid fa-eye-dropper-half fa-4x"></i> <!-- .element: style="float: right;" -->

Practice of collecting only a subset of metrics, logs, and traces

Reduces the overhead of collecting and storing all data

Example: collect only error traces, drop specific labels, drop metrics with specific labels

### Suggestion

Do NOT collect data that you do not need

---

## Comparison

Type    | Description                   | Purpose                   | Example                    |
--------|-------------------------------|---------------------------|----------------------------|
Metrics | Quantative values             | State, trends             | Memory usage, latency      |
Logs    | Event-based, textual data     | Detailed analysis         | Error messages, debug info |
Traces  | Trace requests across systems | Performance, dependencies | Request state, correlation |
