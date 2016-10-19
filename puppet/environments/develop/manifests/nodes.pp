
node 'puppetmaster.ec2.internal' 
inherits 'tomcat_default' 
{

notify{"The machine architecture is $architecture $operatingsystem":}

 if $osfamily == 'redhat' {
   notify{ '1':
   message  =>  "the os is redhat"}
 }
 elsif $osfamily == 'debian' {
   notify{ '2':
   message  =>  "the os is debian"}
 }
 else {
   notify{ '3':
   message  =>  "unknown os"}
 }
 class { 'linux': }


}

node 'tomcat_default' {

 if $osfamily == 'redhat' {
   class { 'java': package => 'java-1.8.0-openjdk-devel', }
 }
  elsif $osfamily == 'debian' {
   class { 'java': version => 8, }

 } else {

   #fail('Invalid OS')
 }

 # install package
 # CATALINA_HOME
 tomcat::install { '/opt/tomcat8': source_url => 'http://apache.osuosl.org/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz',
 }

 # Instance Identifier
 tomcat::instance { 'default': catalina_home => '/opt/tomcat8', }

 # Shutdown Port
 tomcat::config::server { 'default':
   catalina_base => '/opt/tomcat8',
   port          => '8006',
 }

 tomcat::config::server::connector { 'default':
   catalina_base         => '/opt/tomcat8',
   port                  => '8081',
   protocol              => 'HTTP/1.1',
 }
}

class linux {
 $admintools = ['git', 'nano', 'screen']

 package { $admintools: ensure => 'installed', }

 $ntpservice = $osfamily ? {
   'redhat' => 'ntpd',
   'debian' => 'ntp',
   default  => 'ntp',
 }

 package { $ntpservice: ensure => 'installed', }

 service { $ntpservice:
   ensure => 'running',
   enable => true,
 }

}
