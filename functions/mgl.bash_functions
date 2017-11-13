mgl.miseq.analyze () 
{ 
    miseqId="${1}";
    [ -z "${miseqId}" ] && miseqId=$(cat ~/tmp/miseq.id.txt);
    [ -z "${miseqId}" ] && return;
    [ -d /data/MiSeq/ruo/Illumina/MiSeqOutput/"${miseqId}"/Data/Intensities/BaseCalls/Alignment/ ] || return;
    [ -f /data/MiSeq/ruo/Illumina/MiSeqOutput/${miseqId}/pdxpushed.txt ] || return;
    [ -f ~/tmp/miseq.id.txt ] && \mv -f ~/tmp/miseq.id.txt ~/tmp/miseq.id.done.txt;
    source ~/pdx.curl.config;
    curl -L -i -s -H "${pdx_auth}" http://reviewer.phsmgl.info:9991/api_start_miseq_update | tee /tmp/miseq.zfoo.txt
}
