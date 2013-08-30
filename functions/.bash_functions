apache.conf.vhost.tsv () 
{ 
    perl -MEnglish -w -MEnglish -w -lane '
if (/^\s*#/) { next ; } 
elsif (/<VirtualHost/) { ($vhost,$port)=(split(/[:>]/, $F[1]))[0,1] ; $servername=$serveraliases=$docroot="" ; } 
elsif (/ServerName/) { $servername=$serveraliases=$F[1] ; }
elsif (/ServerAlias/) { shift @F ; $serveraliases=join(":", $servername, @F) ; }
elsif (/DocumentRoot/) { $docroot=$F[1] ; } 
elsif (/<\/VirtualHost/) { 
  $servername=$serveraliases="default" if $servername eq "" ;
  foreach $serveralias (split(":", $serveraliases)) {
    print join("\t", $vhost, $port, $servername, $serveralias, $docroot); 
  }
} 
'
}
apache.vhost.tsv () 
{ 
    { 
        [ -f /etc/apache2/envvars ] && . /etc/apache2/envvars && apache2 -S 2> /dev/null || httpd -S 2>&1
    } | perl -MEnglish -w -MEnglish -w -lane '
next unless defined $F[2] ;
if ($F[-1] eq "NameVirtualHost") { ($ip,$port) = split(":",$F[0]) ; next }  ;
if ($F[0] eq "default") {$type=$F[0]; $site=$F[2] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
elsif ($F[2] eq "namevhost") { $type=$F[2]; $site=$F[3] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
elsif ($F[0] =~ /^[0-9]/) { $type="vhost" ; ($ip,$port) = split(":",$F[0]) ; $site=$F[1] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
else { next ; };
print join("\t", $type, $ip, $port, $site, $conf, $line) 
; '
}
group.id () 
{ 
    [ "${1}" ] && awk -F: -v re="^${1}$" '$1 ~ re {print $3}' /etc/group || echo "Usage: $FUNCNAME <group name> "
}
mysql.grants.dump () 
{ 
    mysql -B -N $@ -e "SELECT DISTINCT CONCAT(
    'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
    ) AS query FROM mysql.user" | mysql -f $@ 2>&1 | sed -re '/^GRANT /s/$/;/;/^(Grants|ERROR) /s/^.*$/\n## & ##/'
}
openssl.cert.check () 
{ 
    REMHOST=$1;
    REMPORT=${2:-443};
    echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -noout -subject -dates -issuer
}
openssl.cert.get () 
{ 
    REMHOST=$1;
    REMPORT=${2:-443};
    echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
}
password.create.alnum () 
{ 
    tr -dc '[:alnum:]' < /dev/urandom | head -c20 | fmt
}
password.create.numeric () 
{ 
    tr -dc '[:digit:]' < /dev/urandom | head -c20 | fmt
}
pid.ps () 
{ 
    pid=0;
    [ "$1" -gt 0 ] && pid=$1;
    ps fu -p $pid
}
port.pid () 
{ 
    port=80;
    [ $1 ] && port=$1;
    sudo ss -n -l -p sport = :${port} | tail -n +2 | tr -s ' ' '\t' | cut -f5 | cut -d, -f2
}
