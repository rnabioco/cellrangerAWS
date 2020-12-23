# cellrangerAWS

This tutorial will cover how to use the cellrangerAWS command line tool. This
tool automates the steps required to process scRNA-seq/CITE-seq/scVDJ-seq data
through the Cell Ranger (10x Genomics) pipeline using an AWS EC2 instance.
Instances launched using the cellrangerAWS tool should automatically terminate
when the run is complete. **However, it is the responsibility of the user to 
monitor their AWS console to ensure that instances properly terminate.**

### AWS pricing

To use any resources provided by Amazon Web Services, you will need a credit
card. When launching any EC2 instance, you will be charged for the total time 
the instance is running, regardless of use. Review the following pricing guides:

* [Simple Storage Service (S3)](https://aws.amazon.com/s3/pricing/)

* [Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2/pricing/on-demand/)

### AWS documentation

This tutorial will require you to interact with several AWS portals. Review the
basic documentation for the following portals:

* [Simple Storage Service (S3)](https://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html)

* [Elastic Compute Cloud (EC2)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

* [Identity and Access Management (IAM)](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

### Availability zones

The resources provided by AWS are divided into availability zones. The
availability zone can be selected using a drop-down menu in the top right
corner of the console next to the "Support" menu. Keep the availability zone the
same when configuring your account and when launching EC2 instances. This 
includes when you create an ssh key pair, modify security group settings, create
an S3 bucket, and launch an EC2 instance. If you change settings for one 
availability zone, they will not apply to other zones. It should also be noted
that when looking at your EC2 console, instances will only be listed for your
current availability zone.

### Configuring your AWS account

The cellrangerAWS tool requires that you install the AWS command line interface
and configure your account to allow access to AWS resources. To configure your
account, follow these steps:

1. Create an AWS account [here](https://aws.amazon.com/console/).

2. Download and install the [AWS command line interface](https://aws.amazon.com/cli/).

3. To allow the AWS CLI to issue commands to your AWS account, an access key
must be created using the IAM portal. For security do not save an additional
copy of your key, instead view the key in the IAM portal and paste the access
key and key ID into terminal when prompted. Your key will be automatically saved
in a text file in your home directory (~/.aws/credentials). If you lose your
key, a new one can be generated. **It is important that your AWS access key is
kept private since it provides direct access to your account.**

	Once your key has been generated, run the following command to add your
key information. You will also be asked to provide a default output format,
which needs to be "json".

``` bash
aws configure
```

4. To communicate with the EC2 instances you launch, you must create ssh keys. 
To do this navigate to the EC2 portal and select "Key Pairs" from the left
panel. After creating your key pair, download and save. ssh key pairs are usually
stored in a folder in your home directory (~/.ssh/). Your key pair should be
kept private, anyone with the key pair will be able to remotely access your
instances. 

	After saving your key pair, the permissions must be changed using the
following command:

``` bash
chmod 600 ~/.ssh/my_ssh_key.pem
```

5. To connect with your EC2 instances you must modify the default EC2 security
group, which controls the inbound traffic allowed to reach your instances. To do
this, navigate to the EC2 portal and select "Security Groups" from the left
panel. Select the default group and under "Actions" select "Edit inbound rules".
Under "Source" select "My IP". If desired, you can also specify a range of IP
addresses. Selecting "Anywhere" will allow traffic from all IP addresses (this
is less secure).

6. You will need to grant your EC2 instances access to your S3 bucket by 
generating an new IAM role. To do this, naviate to the IAM Management
Console. Select Roles, click create role, select AWS serice, select EC2,
click Next: Permissions, then filter for ‘AmazonS3FullAccess’ then click checkbox 
next to it, click Next: Tags (leave blank or add tag if desired), click Next: Review, 
enter a Role name such as ‘S3FullAccessEC2’, then finally click Create role. 
You will supply the Role name to the cellrangerAWS tool at the command
line. 

7. By default there are limits placed on the EC2 resources that a user has
access to. EC2 limits are based on the total number of virtual CPUs that
can be used. For example to launch an c5.24xlarge intance (96 CPUs) your EC2
instance limit must be >96. A good starting point is to request a limit of 200.
To request a limit increase follow these [instructions](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-instance-limit/).

### Using the cellrangerAWS command line tool

The cellrangerAWS tool will launch an EC2 instance preconfigured with the Cell 
Ranger references and a snakemake pipeline to run Cell Ranger 3.1.0. The input
fastq files are transferred from an S3 bucket that the user creates to the
running instance. After the Cell Ranger run is complete (or exits), the output
files are transferred back to the S3 bucket and the instance is terminated. To
use the cellrangerAWS tool, follow these steps:

1. cellrangerAWS can be downloaded by right-clicking and saving this
[link](https://github.com/rnabioco/cellrangerAWS/raw/master/cellrangerAWS).
After downloading, make the file executable and copy to your bin directory using
the following commands:

``` bash
chmod 750 cellrangerAWS

# For linux
cp cellrangerAWS ~/.local/bin
```

2. The input fastq files must be uploaded to an S3 bucket. To do this, go to the
S3 portal and select "Create Bucket". Keep all the default settings and create
your bucket. Drag your fastq files into the bucket, a progress bar should appear
at the bottom of the screen. Depending on the size of your files, this could
take several hours.

3. The snakemake pipeline that runs on the instance requires a configuration
file specifying the genome and the sample names. The sample name should be the
fastq file prefix that is shared by all files generated for the capture. For
gene expression data there should be eight separate fastq files that share the 
same prefix. In the config file, the sample names must be listed with one name
per line. A template config file that can be used to run the test ("tiny") data
provided by 10x genomics can be downloaded by right-clicking and saving this
[link](https://github.com/rnabioco/cellrangerAWS/raw/master/PIPELINE/config.yaml).

4. To launch an EC2 instance and start a Cell Ranger run, cellrangerAWS
requires the following arguments:

	-s, the name of your S3 bucket

	-c, the path to your config file

	-k, the path to the ssh key you generated earlier

	-t, the type of EC2 instance you want to use

	-z, the availability zone (default is us-west-2a)
    
    -g, the name of the IAM role you generated to allow EC2 access to your 
        S3 bucket (default is S3FullAccessEC2) 

### Running the test data

Before running your samples, you should first try the test data. To do this
download the test ("tiny") fastq files
[here](https://github.com/rnabioco/cellrangerAWS/tree/master/DATA/tiny_data)
and transfer to an S3 bucket. You can use the config.yaml that you downloaded
in step 3 from above. Here are example commands to run the test data on a
t3a.xlarge instance (4 CPUs). You just need to add the name of your S3 bucket
and the path to your ssh key (-s and -k options).

``` bash
cellrangerAWS -s my-s3-bucket -c config.yaml -k ~/.ssh/my_ssh_key.pem -t t3a.xlarge
```

