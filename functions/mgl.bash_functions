mgl.miseq.analyze () 
{ 
    miseqId="${1}";
    [ -z "${miseqId}" ] && miseqId=$(cat ~/tmp/miseq.id.txt 2> /dev/null);
    [ -z "${miseqId}" ] && return;
    [ -d /data/MiSeq/ruo/Illumina/MiSeqOutput/"${miseqId}"/Data/Intensities/BaseCalls/Alignment/ ] || return;
    until [ -f /data/MiSeq/ruo/Illumina/MiSeqOutput/"${miseqId}"/pdxpushed.txt ]; do
        date;
        sleep 60;
    done;
    source ~/pdx.curl.config;
    curl -L -i -s -H "${pdx_auth}" http://reviewer.phsmgl.info:9991/api_start_miseq_update | tee /tmp/miseq.zfoo.txt;
    [ -f ~/tmp/miseq.id.txt ] && \mv -f ~/tmp/miseq.id.txt ~/tmp/miseq.id.done.txt
}
