
oc_ps1() {
    config=~/.kube/config
    # collect both times in seconds-since-the-epoch
    one_day_ago=$($GDATE -d 'now - 1 days' +%s)
    file_time=$($GDATE -r "$config" +%s)
    if (( file_time > one_day_ago )) ; then
        # Get current context
        CONTEXT=$(cat $config 2>/dev/null| grep -o '^current-context: [^/]*' | cut -d' ' -f2)
        if [ -n "$CONTEXT" ]; then
            echo "(${CONTEXT##*-})"
        fi
    fi
}

oc_get_first_pod() {
  reg="${1:-.*}"
  oc get pod --no-headers | awk -v r="$reg"  '$1 ~ r {print $1}' | head -1
}

oc_get_first_deployment() {
  reg="${1:-.*}"
  oc get deployment --no-headers | awk -v r="$reg"  '$1 ~ r {print $1}' | head -1
}

oc_setup_deployment_debug() {
  deployment=$(oc_get_first_deployment $1)
  echo deployment: $deployment
  oc set env deployment/$deployment JPDA_ADDRESS=8000
  oc set env deployment/$deployment JPDA_TRANSPORT=dt_socket

  echo open tunnel with "oc port-forward $(oc_get_first_pod) 8000:8000"

}

oc_connect_debug() {
  pod=$(oc_get_first_pod $1)
  oc port-forward $pod 8000:8000

}

oc_rsh() {
  pod=$(oc_get_first_pod $1)
  oc rsh $pod

}