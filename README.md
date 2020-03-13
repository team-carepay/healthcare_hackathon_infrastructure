# Infrastructure for the CarePay Hackathon

This is the infrastructure we used at CarePay to host the Healthcare hackathon. In the hackathon several teams worked on analysing healthcare data and training machine learning models on that data. We needed to ensure a certain level of safety of the data. So we decided to set up the following infrastructure for the participants:

- S3 bucket for storing data.
- CodeCommit repository for teams to store their notebooks in.
- SageMaker notebooks with access to both the s3 bucket and the CodeCommit repository. Notably we disable the download button in the notebooks.
- An IAM user to access the SageMaker instance. Notably we only allowed access from our office IP.

## Access to instance

```console
export AWS_ACCESS_KEY_ID=<provided-key>
export AWS_SECRET_ACCESS_KEY=<provided-secret>
aws sagemaker create-presigned-notebook-instance-url --notebook-instance-name demo
```

## Uploading data to the bucket

```console
aws s3api put-object --bucket cp-hackathon-data --key test.csv --body ./my.csv
```

## Loading in data in the Notebook

```python
import boto3
import pandas as pd
from sagemaker import get_execution_role

role = get_execution_role()
bucket='hackathon-data'
data_key = 'test.csv'
data_location = 's3://{}/{}'.format(bucket, data_key)

pd.read_csv(data_location)
```