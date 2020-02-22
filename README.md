# cellrangerAWS

This tutorial will require you to access three separate AWS portals:

1. Simple Storage Service, S3 (https://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

2. Elastic Compute Cloud, EC2 (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

3. Identity and Access Management, IAM (https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

To configure your AWS account and start a Cell Ranger run follow these steps:

1. First create an AWS account (https://aws.amazon.com/console/).

2. Download and install the AWS command line interface (https://aws.amazon.com/cli/).

3. To link your computer to your AWS account you must create access keys using
the IAM portal. Use the "aws configure" command to add your access key and 
key ID to the AWS CLI.

4. To communicate with the EC2 instances that you launch, you must create ssh
keys by selecting "Key Pairs" from the left panel of the portal. Download and
save your key in a safe place on your computer.

5. To connect with your instances you must modify the default EC2 security
group. To do this select "Security Groups" from the left panel of the portal.
Select the default group and under "Actions" select "Edit inbound rules". Under
"Source" select "My IP". You can also select "Anywhere" if you will be accessing
your account from multiple IP addresses (this is less secure).

6. By default new AWS accounts will not have access to the resources required to
run Cell Ranger. To request a limit increase follow these instructions:
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-instance-limit/

7. To run Cell Ranger, the input fastq files must be uploaded to an S3 bucket.
To do this go to the S3 portal, select "Create Bucket", and drag your files into
the window.

8. Add your sample names to the config.yaml. There is a sample yaml in the
PIPELINE directory of this repository.

9. To start a Cell Ranger run there are four arguments you need to pass to 
cellrangerAWS:

	-s, the name of your S3 bucket

	-c, the path to your config.yaml

	-k, the path to the ssh key you generated earlier

	-t, the type of EC2 instance you want to use


