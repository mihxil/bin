

jv_apple() {
    if [ "$1" == "7" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v 1.7.0_60`
        java -version
    elif [ "$1" == "oracle8" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v  1.8.0_211`
        java -version

    elif [ "$1" == "8" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v  1.8.0_232`
        #export JAVA_HOME=`/usr/libexec/java_home -v  1.8.0_172`
        java -version
    elif [ "$1" == "open8" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v  1.8.0_232`
        java -version
    elif [ "$1" == "9" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v 9`
        java -version
    elif [ "$1" == "11" ] ; then
        export JAVA_HOME=`/usr/libexec/java_home -v 11`
        java -version
    elif [ "$1" == "" ] ; then
        java -version
    else
        echo UNSUPPORTED
    fi
}



jv_ubuntu() {
    if [ "$1" == "" ] ; then
        java -version
    elif [ "$1" == "8" ] ; then
        v=$(update-java-alternatives -l | grep '1\.8' | cut -d " " -f1)
        sudo update-java-alternatives --set $v
        java -version
    else
        v=$(update-java-alternatives -l | grep "java-1.$1" | cut -d " " -f1)
        sudo update-java-alternatives --set $v
        java -version
    fi
}



jv() {
    if which update-java-alternatives ; then
        jv_ubuntu $@
    else
        jv_apple $@
    fi
}
