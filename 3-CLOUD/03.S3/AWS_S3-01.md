# Cloud Services - AWS S3 - 01

### Objectives:
- To know what AWS S3 is and its purpose. 
- To be able to create Buckets in AWS S3
- Explain the basic pricing that’s used by Amazon S3.


## Amazon Simple Storage Service (Amazon S3)

- Objects can be almost any data file, such as documents, images or videos. 

- When you add objects to a bucket, you must give them a unique name, which is called an object key. 
  Bucket names must be unique across all existing bucket names in Amazon S3.

- Amazon S3 is object-level storage. Data is stored as objects in buckets.
  If you want to change a part of a file, you must make the change and then re-upload the entire modified file.

- Virtually unlimited storage. But a single object can be up to 5 TB.

- Designed for 11 9s (99.999999999 %) of durability.

- By default, your data is private, and you can optionally encrypt it.

- You can retrieve data anytime from anywhere over the internet



**Redundancy in Amazon S3**
- When you create a bucket in Amazon S3, it’s associated with a specific AWS Region. Whenever you store data in the bucket, it’s redundantly stored across multiple AWS facilities in your selected Region.


**Seamless scaling**
- Amazon S3 automatically manages the storage behind your bucket even when your data grows. This behavior enables you to get started immediately and to have your data storage grow with your application needs.


**Common use cases**
- Storing application assets
- Static web hosting
- Backup and disaster recovery (DR)




## Amazon S3 Classes

Amazon S3 offers 6 different storage classes that are designed for different use cases.

Based on the use case you are given, choose the right storage class to optimize performance and cost for your project.



**S3 Standard**
- Active, frequently accessed data.

**S3 Intelligent-Tiering**
- Data with changing access patterns.
- Minimum storage duration.
- Per-object monitoring fee.

**S3 Standard-AI**
- Infrequently accessed data.
- Minimum storage duration and object size.

**S3 One Zone-AI**
- Active, frequently accessed data.
- Minimum storage duration and object size.
- Retrieval fee GB.

**S3 Glacier**
- Active, frequently accessed data.
- Minimum storage and object size.
- Retrieval fee GB.
- Retrieval min/hours.

**S3 Glacier Deep Archive**
- Active, frequently accessed data.
- Minimum storage duration and object size.
- Retrieval fee GB.
- Retrieval in hours.



## Pricing

**Pay only for what you use:** 

1. GBs per month  
2. Transfer OUT to other Regions or to the Internet
3. PUT, COPY, POST, GET etc. requests


**You do NOT have to pay for:**

- Transfer IN to Amazon S3.
- Transfer OUT from Amazon S3 to Amazon CloudFront or Amazon EC2 in the same Region.

With Amazon S3, specific costs might vary, depending on the Region and the specific requests that are made. 
You pay only for what you use, including GB per month.


### S3 Cost Estimation

To estimate Amazon S3 costs, consider the following: 

1. Storage class type
   - Select a cost-efficient storage tier which fits your use case

2. Amount of storage
   - Calculate the number and size of objects you will be storing in S3

3. Requests
   - Estimate the number and type of requests (GET, PUT, COPY)

4. Data transfer
   - Consider the amount of data that is transferred out of AWS into another Region or to the internet.

#### Ensure the Bucket is Publicly Accessible

By default, AWS S3 blocks all public access. You need to modify the bucket's public access settings.
Steps:

Go to the S3 Console in AWS.
Select your bucket.
Click Permissions → Block public access (bucket settings).
Uncheck Block all public access (or adjust based on your needs).
Save changes.

### Bucket Policy if you want to make all resources in a bucket public

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::testpiet/*"
        }
    ]
}
```
