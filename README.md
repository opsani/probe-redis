# probe-redis
The redis probe connects to and pings redis component instances.  This probe can be used to verify a deployed service provides access to the redis API on the component's service network (the same network which is used to consume that service).

The redis probe supports the following actions:

* `service_up` (default) - connect to and ping redis, retrying until success or the action times out.  Succeed if the redis service is up, even if the connect response is authentication failure or invalid database index.
* `check_access` - connect to and ping redis, retrying until success or the action times out.  Succeed if the redis server responds to ping.  This action can be used to verify access to a password protected redis service.

These actions support the following arguments:

* `port` - port number (default `6379`)
* `password` - password (default `None`)
* `database` - database index (default `0`)
* `timeout` - operation timeout *per service instance*, in seconds (default `30`).  This is how long to keep retrying if the redis service does not respond.

Docker Hub repository:  <https://hub.docker.com/r/opsani/probe-redis/>

## examples

Here are a few examples in the form of quality gates specified in a Skopos TED file (target environment descriptor).  Quality gates associate probe executions to one or more component images.  During application deployment Skopos executes the specified probes to assess components deployed with matching images.

```yaml
quality_gates:
    redis_test:
        images:
            - redis:*
        steps:

            # verify redis service is up (default action service_up)
            - probe: opsani/probe-redis

            # verify redis access
            - probe:
                image: opsani/probe-redis
                action: check_access
                label: "check redis access on alternate port with timeout"
                arguments: { port: 10000, timeout: 15 }
            - probe:
                image: opsani/probe-redis
                action: check_access
                label: "check redis access with password"
                arguments: { password: "${my_password}" }
```
