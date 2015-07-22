#### Overview

This script allows you deleting Zendesk organziation(s) with specific tag.

#### Usage

To run this script enter the following command into your console.

```
ruby org_delete_with_tag_full.rb
```

Script will ask you to provide Zendesk account access.

```
----------------------------------------------------------------
               Script configuration
----------------------------------------------------------------

Please enter your account details below:                        

Subdomain: (e.g mycompany.zendesk.com): mycompany.zendesk.com
Email (e.g admin@company.com): admin@company.com
API Token (will not be displayed): ****************************************


```

Enter organization tag which will be used for search.

```
Enter organization tag:                                         

Tag: (e.g test): my_tag

```

Script will execute the search and display the results.
Results formatted as `ORGANIZATION NAME [ZENDESK ID OF ORGANIZATION]`
Type `y` or `n` to confirm or deny the deletion.

```
----------------------------------------------------------------
              Running script...
----------------------------------------------------------------
Running a search...
Organizat_1333_9_8_4_2_1-1_15 [652988855]
Organizat_1333_9_8_4_2_1-1_14 [652988845]
...
Organ_1333_9_8_4_2_1-1_5 [652285139]
Organ_1333_9_8_4_2_1-1_4 [652285129]
Do you want to proceed with removal of organizations listed above? (y/n)

```
Script will start deleting the organizations.

```
Deleting organizations...
Deleting Organizat_1333_9_8_4_2_1-1_15 [652988855]...
Deleting Organizat_1333_9_8_4_2_1-1_14 [652988845]...
...
Deleting Organ_1333_9_8_4_2_1-1_5 [652285139]...
Deleting Organ_1333_9_8_4_2_1-1_4 [652285129]...

Done! 34 organization(s) deleted.
```
Script will produce a file (deleted_organizations.txt) which will contain all deleted records as well as error messages if any.
File will be saved in the same folder where script is located.

![](https://p4.zdassets.com/hc/theme_assets/201622/2836/Screen_Shot_2015-07-22_at_13.39.29.png)

*Repository also contains simplified version of the script named as org_delete_with_tag_simplified.rb Which works in a similar manner as the full version but has les interactions with the user.*
