# cellrangerAWS

This tutorial will cover how to use the cellrangerAWS command line tool. This
tool automates the steps required to process scRNA-seq/CITE-seq/scVDJ-seq data
through the Cell Ranger (10x Genomics) pipeline using an AWS EC2 instance.
Instances launched using the cellrangerAWS tool should automatically terminate
when the run is complete. **However, it is the responsibility of the user to 
monitor their AWS console to ensure that instances properly terminate so they do
not incur additional charges.**

### AWS pricing

To use any resources provided by Amazon Web Services, you will need a credit
card. When launching any EC2 instance, you will be charged for the total time 
the instance is running, regardless of use. Please carefully review the 
following pricing guides:

* Simple Storage Service, S3 (https://aws.amazon.com/s3/pricing/)

* Elastic Compute Cloud, EC2 (https://aws.amazon.com/ec2/pricing/on-demand/)

### AWS Documentation

This tutorial will require you to access the following AWS portals:

* Simple Storage Service, S3 (https://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

* Elastic Compute Cloud, EC2 (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

* Identity and Access Management, IAM (https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

### Configuring your AWS account

To configure your AWS account and start a Cell Ranger run, follow these steps:

1. First create an AWS account (https://aws.amazon.com/console/).

2. Download and install the AWS command line interface (https://aws.amazon.com/cli/).

3. To allow the AWS CLI to issue commands to your AWS account, an access key
must be created using the IAM portal. Once your key has been generated run the
following command to add your key information. For security do not save an
additional copy of your key, instead view the key in the IAM portal and paste
the access key and key ID into terminal when prompted. Your key will be
automatically saved in a text file in your home directory: .aws/credentials.
If you lose your key, a new one can be generated. **It is important that your 
AWS access key is kept private since it provides direct access to your
account.**

``` bash
aws configure
```

4. To communicate with the EC2 instances you launch, you must create ssh keys by
selecting "Key Pairs" from the left panel of the portal. Download and save your
keys in a safe place.

5. To connect with your instances you must modify the default EC2 security
group. To do this select "Security Groups" from the left panel of the portal.
Select the default group and under "Actions" select "Edit inbound rules". Under
"Source" select "My IP". You can also select "Anywhere" if you will be accessing
your account from multiple IP addresses (this is less secure).

6. By default new AWS accounts will not have access to the resources required to
run Cell Ranger. To request a limit increase follow these instructions:
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-instance-limit/

### Using the cellrangerAWS command line tool

To use the cellrangerAWS command line tool, follow these steps:

1. The input fastq files must be uploaded to an S3 bucket. To do this go to the
S3 portal, select "Create Bucket", and drag your files into the window.

2. Add your sample names to the config.yaml. There is a sample yaml in the
PIPELINE directory of this repository.

3. To start a Cell Ranger run there are four arguments you need to pass to 
cellrangerAWS:

	-s, the name of your S3 bucket

	-c, the path to your config.yaml

	-k, the path to the ssh key you generated earlier

	-t, the type of EC2 instance you want to use


