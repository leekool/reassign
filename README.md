### reassign
bash script that uses the [Jira API](https://developer.atlassian.com/cloud/jira/platform/rest/v3/) to assign a ticket to the person who assigned it to you

depends on [jq](https://jqlang.github.io/jq/) for parsing JSON

---

after cloning, reassign.sh needs to be edited to populate the global variables

    EMAIL=""
    URL=""
    TOKEN=""

EMAIL - the email you use to login to Jira

URL - your organisation's Jira URL

TOKEN - a Jira API token ([get a Jira API token](https://id.atlassian.com/manage-profile/security/api-tokens))

---
##### usage

the script takes a ticket ID as an argument, e.g.

    ./reassign.sh ISSUE-1

