# Solaris to Elasticsearch

## Architecture
![Architecture flow](https://i.imgur.com/fzSq5bb.png)

This setup requires:
- 1 Solaris 10 VM
- 2 Linux VMs (one for the NFS host, one for the Forwarder)

# Instructions

*Note: This guide assumes you have already set up an NFS share.* 

First, configure the `grepData` and `curl.sh` scripts in your NFS directory using your preferred text editor. 

Next, create an Index Template using Kibana Dev Tools:

```json
PUT _index_template/solaris_logs_template
{
  "index_patterns": ["logs-solaris-*"],
  "data_stream": { },
  "template": {
    "settings": {
      "index.mode": "logsdb"
    }
  },
  "priority": 500
}
```
The output should return `{"acknowledged": true}`. Once confirmed, proceed with the following steps:
1.  Mount the NFS share from the NFS host onto the Solaris 10 VM.
2.  Copy the `grepData` script into the `/bin` directory on the Solaris host.
3.  Create a cron job on the Solaris host to run every 30 seconds to collect metrics.
4.  Mount the same NFS share onto the Linux Forwarder VM.
5.  Copy the `curl.sh` script onto the Forwarder VM.
6.  Create a cron job on the Forwarder VM to run every 30 seconds to send the generated `solaris_stat_*.json` files to Elasticsearch.
### Verification

Verify your data is arriving in Kibana by navigating to **Stack Management > Index Management**, toggling **Include hidden indices**, and searching for "solaris".

Once you confirm the data is successfully indexed in Elasticsearch, you can proceed to import your Dashboard and Data View.
