apache.conf.vhost.tsv () 
{ 
    perl -MEnglish -w -lane '
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
    } | perl -MEnglish -w -lane '
next unless defined $F[2] ;
if ($F[-1] eq "NameVirtualHost") { ($ip,$port) = split(":",$F[0]) ; next }  ;
if ($F[0] eq "default") {$type=$F[0]; $site=$F[2] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
elsif ($F[2] eq "namevhost") { $type=$F[2]; $site=$F[3] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
elsif ($F[0] =~ /^[0-9]/) { $type="vhost" ; ($ip,$port) = split(":",$F[0]) ; $site=$F[1] ; ($conf, $line) = (split(/[)(:]/,$F[-1]))[1,2] ; }
else { next ; };
print join("\t", $type, $ip, $port, $site, $conf, $line) 
; '
}
disk.write.test () 
{ 
    [ "$1" -gt 0 ] && tmpfile=$(mktemp zfoo.XXXXX) && dd if=/dev/zero of=${tmpfile} bs=1000000 count=$1 && sync;
    \rm ${tmpfile}
}
ec2.metadata.display () 
{ 
    local item="$1";
    for name in $(curl -s http://169.254.169.254/latest/meta-data/${item});
    do
        if [ -z ${name%%*/} ]; then
            echo ${name};
            ec2.metadata.display "${item}/${name}" | sed -e 's/^/  /';
        else
            if [ ${name%%=*} != ${name} ]; then
                echo ${name%%=*}/;
                ec2.metadata.display "${item}/${name%%=*}/" | sed -e 's/^/  /';
            else
                echo ${name}=$(curl -s http://169.254.169.254/latest/meta-data/${item}/${name});
            fi;
        fi;
    done
}

ec2.userdata.display ()
{
curl -s http://169.254.169.254/latest/user-data/ ; echo
}

group.id () 
{ 
    [ "${1}" ] && awk -F: -v re="^${1}$" '$1 ~ re {print $3}' /etc/group || echo "Usage: $FUNCNAME <group name> "
}
memc.add () 
{ 
    host=localhost;
    [ $4 ] && host=$4;
    { 
        cmd=add;
        [ $1 ] || return;
        key=$(echo $1 | cut -d= -f1);
        value=$(echo $1 | cut -d= -f2);
        bytes=${#value};
        flags=0;
        [ $2 ] && flags=$2;
        exptime=600;
        [ $3 ] && exptime=$3;
        echo -e "${cmd} ${key} ${flags} ${exptime} ${bytes}\r";
        echo -e "${value}\r";
        sleep .1
    } | netcat ${host} 11211
}
memc.get () 
{ 
    host=localhost;
    [ $2 ] && host=$2;
    { 
        cmd=get;
        [ $1 ] || return;
        key=$1;
        echo -e "${cmd} ${key}\r";
        sleep .1
    } | netcat ${host} 11211
}
memc.stats () 
{ 
    host=localhost;
    [ $1 ] && host=$1;
    { 
        echo -e "stats\r\nquit\r\n";
        sleep .1
    } | netcat ${host} 11211
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
openssl.cert.fulltext () 
{ 
    REMHOST=$1;
    REMPORT=${2:-443};
    echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -noout -text
}
openssl.modulus.md5sum () 
{ 
    local file ext cmd exts;
    declare -A exts;
    exts=([key]="rsa" [crt]="x509" [csr]="req");
    while [ "$#" -gt 0 ]; do
        file=$1;
        shift;
        ext=${file##*.};
        cmd=${exts[$ext]};
        echo ${file} $(openssl ${cmd} -noout -modulus -in ${file} | md5sum | cut -d" " -f1 )
    done
}


openssl.modulus () 
{ 
    local file ext cmd exts;
    declare -A exts;
    exts=([key]="rsa" [crt]="x509" [csr]="req");
    while [ "$#" -gt 0 ]; do
        file=$1;
        shift;
        ext=${file##*.};
        cmd=${exts[$ext]};
        echo == ${file};
        openssl ${cmd} -noout -modulus -in ${file};
    done
}

openssl.protocol.test () {
proto=ssl2
ip=127.0.0.1
port=443
[ "$1" ] && ip="$1"
echo ${ip}:${port} = $(
echo | openssl s_client -${proto} -connect ${ip}:${port} 2> /dev/null | grep -q Cipher && echo yes ${proto} || echo no ${proto}
)
}

password.create.alnum () 
{ 
    LANG=C tr -dc '[:alnum:]' < /dev/urandom | head -c20 | fmt
}
password.create.numeric () 
{ 
    LANG=C tr -dc '[:digit:]' < /dev/urandom | head -c20 | fmt
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
site.info () 
{ 
    website=www.example.com;
    [ ${1} ] && website="${1}";
    domain=$(<<< ${website} cut -d. -f2- );
    echo == registrar;
    whois ${domain};
    echo == hosting;
    dig +short ${website} | xargs -n1 -r whois;
    echo == IP website;
    dig +noall +answer ${website};
    echo == reverse DNS;
    dig +short ${website} | xargs -n1 -r dig +noall +answer -x;
    echo == double reverse DNS;
    dig +short ${website} | xargs -n1 -r dig +short -x | xargs -n1 -r dig +noall +answer;
    echo == IP domain;
    dig +noall +answer ${domain};
    echo == all DNS records for domain;
    dig +noall +answer ${domain} ANY;
    echo == webserver;
    curl -s -I -A foobar http://${website}/
}
