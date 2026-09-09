
GDATE=${GDATE:-/usr/bin/date}

# Prints the suffix of the current OpenShift context for use in a shell prompt.
#
# Outputs nothing when ~/.kube/config is older than one day or has no current
# context.

oc_ps1() {
    local config=~/.kube/config
    # collect both times in seconds-since-the-epoch
    local one_day_ago
    local file_time
    one_day_ago=$($GDATE -d 'now - 1 days' +%s)
    file_time=$($GDATE -r "$config" +%s)
    if (( file_time > one_day_ago )) ; then
        # Get current context
        local CONTEXT=$(cat $config 2>/dev/null| grep -o '^current-context: [^/]*' | cut -d' ' -f2)

        if [ -n "$CONTEXT" ]; then
            NS=$(oc config get-contexts ${CONTEXT} --no-headers | awk '{print $5}')
            echo "(${CONTEXT} $NS)"
        fi
    fi
}


# Prints the name of the first pod whose name matches the optional regex.
#
# Arguments:
#   $1 - Regular expression to match pod names; defaults to matching all pods.
oc_get_first_pod() {
  reg="${1:-.*}"
  oc get pod --no-headers -o custom-columns=name:.metadata.name | grep -E "$reg" | head -1
}

# Prints the name of the first deployment whose name matches the optional regex.
#
# Arguments:
#   $1 - Regular expression to match deployment names; defaults to matching all deployments.
oc_get_first_deployment() {
  reg="${1:-.*}"
  oc get deployment --no-headers -o custom-columns=name:.metadata.name | grep -E "$reg" | head -1
}

# Enables Java remote debugging on port 8000 for the first matching deployment.
#
# Arguments:
#   $1 - Optional regular expression used to select the deployment.
#
# Updates the deployment's JPDA_ADDRESS and JPDA_TRANSPORT environment variables
# and prints the port-forward command needed to attach a debugger.
oc_setup_deployment_debug() {
  deployment=$(oc_get_first_deployment $1)
  echo deployment: $deployment
  oc set env deployment/$deployment JPDA_ADDRESS=8000
  oc set env deployment/$deployment JPDA_TRANSPORT=dt_socket

  echo open tunnel with "oc port-forward $(oc_get_first_pod) 8000:8000"

}

# Forwards local port 8000 to port 8000 on the first matching pod.
#
# Arguments:
#   $1 - Optional regular expression used to select the pod.
#
# Runs until the port-forward process is interrupted.
oc_connect_debug() {
  pod=$(oc_get_first_pod $1)
  oc port-forward $pod 8000:8000

}

# Opens a remote shell in the first matching pod.
#
# Arguments:
#   $1 - Optional regular expression used to select the pod.
oc_rsh() {
  pod=$(oc_get_first_pod $1)
  oc rsh $pod
}


# Prints pod names whose app label has the supplied value.
#
# Arguments:
#   $1 - Required value of the app label.
#   $2 - Number of results to (maximally) return (default to 1)
oc_pod() {
    # app: b&g
    # application: poms
   oc get pod --selector=app=$1 --selector=application=$1 --sort-by=.metadata.creationTimestamp --no-headers -o custom-columns=name:.metadata.name | tail -${2:-1}
}


# Prints pod names for the web application.
oc_web() {
   oc_pod "web"
}
