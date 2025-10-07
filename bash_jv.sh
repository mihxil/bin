

jv_apple() {
    if [ "$1" == "" ] ; then
        java -version
    else
        v=$1
        if [ "$v" == "8" ] ; then
            v="1.8"
        fi
        export JAVA_HOME=`/usr/libexec/java_home -v $v`
        java -version
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
        v=$(update-java-alternatives -l | grep -E "java-1.$1|temurin-$1" | cut -d " " -f1)
        if [ -z "$v" ] ; then
            echo "No version $1 found. Try apt-get install temurin-$1-jdk"
            echo "See https://marcolenzo.eu/install-java-temurin-jdks-instead-of-openjdk/"
            jv
            return
        fi
        sudo update-java-alternatives --set $v
        java -version
    fi
    export JAVA_HOME=`dirname $(dirname $(readlink -f $(which javac)))`
}



jv() {
    if which update-java-alternatives ; then
        jv_ubuntu $@
    else
        jv_apple $@
    fi
    JAVA_VERSION=$(java -version 2>&1 | awk -F[\".] '/version/ {print $2}')
    echo java ${JAVA_VERSION}
    export JAVA_VERSION
    if [ "$JAVA_VERSION" -ge 23 ]; then
        export MAVEN_OPTS=${MAVEN_OPTS_NODEBUG24}
    else
        export MAVEN_OPTS=${MAVEN_OPTS_NODEBUG}
    fi

}
