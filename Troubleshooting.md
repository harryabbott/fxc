I've saved a plan output to plan.txt

```
│ Error: creating EC2 Instance: operation error EC2: RunInstances, https response error StatusCode: 400, RequestID: 9023134b-4109-43fc-8e45-134552e3c2ea, api error Blocked: This account is currently blocked and not recognized as a valid account. Please contact https://support.console.aws.amazon.com/support/home?region=us-east-1#/case/create?issueType=customer-service&serviceCode=account-management&categoryCode=account-verification if you have questions.
│ 
│   with aws_instance.fxc-test,
│   on main.tf line 1, in resource "aws_instance" "fxc-test":
│    1: resource "aws_instance" "fxc-test" {
│ 
╵
```

Got this lovely error while doing a test apply on my personal AWS account. Looking in cloudtrail filtered down to my username:

`"errorMessage": "Value (backup_profile) for parameter iamInstanceProfile.name is invalid. Invalid IAM Instance Profile name",`

So, [this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile#name) says it has to be unique (like s3 bucket name ig?). 

fixed that. re-ran. same error. 

Error in cloudtrail is now:
`"errorMessage": "This account is currently blocked and not recognized as a valid account. Please contact https://support.console.aws.amazon.com/support/home?region=us-east-1#/case/create?issueType=customer-service&serviceCode=account-management&categoryCode=account-verification if you have questions."`

- Stackoverflow said it could be a region thing. I have eu-west-2 enabled in my account already (by default), but figured trying euw1 wouldnt hurt.

- it timed out on creating the resources (specifically, ec2 and s3), so this is likely an account issue. 

- So, manually creating an instance.... same error.

- checked billing - card expired 

- fixed that, changed the region back to euw2, same error.

- might take a while for billing to propogate, so will leave it 12hrs (10pm 10/7/24 rn). 

- one last thing before then, verbosity. `TF_LOG=WARN` + apply just outputs the same error from aws, with a 400 bad request. besides, the manual creation is still erroring with the same blocked message so probs not a tf-exclusive error.

- 12hrs later... no difference in error message. have raised to aws support. will update the repo if theres anything that requires me to fix.

---

# Outputs logic issue

## Issue:
 Task specifies an outputted link to the file \
 so we must use a unique name to keep more backups. logically, this would be the date. \
 chances are this is applied after 2am so the outputted url would be wrong, as the next (first) run would be "tomorrow" where the file would have a diff date to the apply. 

## Currently:
 e.g 1am apply, the cronjob isnt triggered yet (for 1h) so the outputted url points to nothing (until the 2am run, then the url is "live"). \
     3am apply, the cronjob isnt triggered yet (for 23h) so the outputted url will always point to nothing, as the next run will have a different filename. 

 So it would only work as intended in its current state if applied between 00 and 2am, and then there would be a delay on the url working of time-til-2am. 

## Solutions:
 option 1) An easier fix would be outputting a URL to the directory instead, rather than the specific file. but this is not in the task definition.

 option 2) We make an initial run, S3 auto overwrites items of the same name. meaning if ran between 00-2am the initial run would be overwritten at 2am

 option 3) We only keep a single backup, if we want we can then make the S3 bucket versioned.

### I have opted for option 2, since its a 1-liner and will be easier to search a filename for backup than a versioned bucket.