
# avoid warnings from java 24 when using maven
MAVEN_OPTS_ALL="-Xms512m -Xmx6048m -Djava.awt.headless=true -Duser.language=da -ea  -Djava.net.preferIPv4Stack=true"
MAVEN_OPTS_J24="--enable-native-access=ALL-UNNAMED --sun-misc-unsafe-memory-access=allow"
#MAVEN_OPTS_ALL="-Xms512m -Xmx6048m -Djava.awt.headless=true -Duser.language=da -ea  -Djava.net.preferIPv4Stack=true $MAVEN_OPTS_J24"


# -d64 -XX:-UseSuperWord
#export MAVEN_OPTS_NODEBUG='-Xms512m -Xmx3048m -XX:MaxPermSize=512m -Djava.awt.headless=true -Duser.language=da -ea -Dcatalina.base=/Users/tomcat/catalina/ -Djava.net.preferIPv4Stack=true'
#export MAVEN_OPTS_NODEBUG='-Xms512m -Xmx3048m -Djava.awt.headless=true -Duser.language=da -ea  -Dcatalina.base=/Users/tomcat/catalina/ -Djava.net.preferIPv4Stack=true'
export MAVEN_OPTS_NODEBUG8=${MAVEN_OPTS_ALL}
export MAVEN_OPTS_NODEBUG="--add-opens java.base/java.lang=ALL-UNNAMED $MAVEN_OPTS_ALL"
export MAVEN_OPTS_NODEBUG24="$MAVEN_OPTS_NODEBUG  $MAVEN_OPTS_J24"
#export MAVEN_OPTS_DEBUG="-d64 -XX:-UseSuperWord -Xms512m -Xmx3024m -XX:MaxPermSize=512m  -XX:NewSize=4m  -Djava.awt.headless=true -Xnoagent -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n  -Dcatalina.base=/Users/tomcat/"
#export MAVEN_OPTS_DEBUG="-Xms512m -Xmx2048m -Djava.awt.headless=true -Xnoagent -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n  -Dcatalina.base=/Users/tomcat/"
export MAVEN_OPTS_DEBUG="${MAVEN_OPTS_ALL} -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n -ea  -Dcom.sun.management.jmxremote --add-opens java.base/java.lang=ALL-UNNAMED "
#export MAVEN_OPTS_DEBUG2="-Xms512m -Xmx3024m -Djava.awt.headless=true -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4001,server=y,suspend=n -Duser.language=da -ea -Dcatalina.base=/Users/tomcat/catalina/ -Djava.net.preferIPv4Stack=true"
export MAVEN_OPTS_DEBUG2="${MAVEN_OPTS_ALL} -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4001,server=y,suspend=n --add-opens java.base/java.lang=ALL-UNNAMED"

export MAVEN_OPTS_DEBUG8="${MAVEN_OPTS_ALL} -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n"

export MAVEN_OPTS_SOCKS="${MAVEN_OPTS_NODEBUG} -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=10001"
#export MAVEN_OPTS=${MAVEN_OPTS_NODEBUG}


export MAVEN_OPTS=${MAVEN_OPTS_NODEBUG}

#export MAVEN_PROXY=http://localhost:10001

#maven1:
export MAVEN_HOME=${HOME}/Applications/maven-1.1

export INPUT_DETERMINE_VERSION=false
export INPUT_PUBLIC=false
export JOB_ENV=NO

#maven2
alias mvn2='M2_HOME=/opt/local/share/java/maven2 mvn2'
alias mvnd='MAVEN_OPTS=${MAVEN_OPTS_DEBUG}'
alias mvnd2='MAVEN_OPTS=${MAVEN_OPTS_DEBUG2}'
alias mvnnd='MAVEN_OPTS=${MAVEN_OPTS_NODEBUG}'
alias mvn8='MAVEN_OPTS=${MAVEN_OPTS_NODEBUG8}'
alias mvnd8='MAVEN_OPTS=${MAVEN_OPTS_DEBUG8}'
alias mvn="mvn --threads 1C"
alias mvnc="/usr/local/bin/mvn"
function mvnt() {
    LC_CTYPE=UTF-8 mvn -DskipTests=false -DfailIfNoTests=false -D"maven.test.failure.ignore=true" $1
    after_maven
}
function mvnT() {
    LC_CTYPE=UTF-8 mvn -DskipTests=false -DskipITs=false -DfailIfNoTests=false -D"maven.test.failure.ignore=true" $1
    after_maven
}
alias mvn_clean_repo="mvn -Dmaven.repo.local=$HOME/.m2/repository_clean"

alias mvnsocks='MAVEN_OPTS=${MAVEN_OPTS_SOCKS}'
alias mvnp="mvn --threads 1"
alias mvnm="mvn -P\!npm,\!analyze"
alias mci="mvn clean install"
alias mvnff="mvn -DskipTests=false -Dsurefire.skipAfterFailureCount=1 --threads 1"
