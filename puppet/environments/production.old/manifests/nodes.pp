node 'wiki.hsd1.pa.comcast.net'  {

#  file { '/info.txt':
#    ensure => 'present',
#    content => inline_template("Created by puppet at <%= Time.now %>\n"),
#  }

  class {'linux':}

}

node 'wikitest.hsd1.pa.comcast.net' {

  class {'linux':}


}
node 'wikitest1.hsd1.pa.comcast.net' {

  class {'linux':}

}
node 'ip-172-31-51-138.ec2.internal' {


  file { '/info.txt':
    ensure  => 'present',
    content => inline_template("Created by Puppet at <%= Time.now %>\n"),
  }

}

class linux {

  $admintools = ['git', 'nano', 'screen']

  package { $admintools:
    ensure => 'installed',
  }

  $ntpservice = $osfamily ? {
    'redhat' => 'ntpd',
    'debian' => 'ntp',
    default  => 'ntp',
  }

  file { '/info.txt':
    ensure  => 'present',
    content => inline_template("Created by Puppet at <%= Time.now %>\n"),
  }

  package { 'ntp':
    ensure => 'installed',
  }

  service { $ntpservice:
    ensure => 'running',
    enable => true,
  }

}
