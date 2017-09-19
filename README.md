# Portfolio

Repo for my personal portfolio, accessible available at [ryanloader.me](http://ryanloader.me/).

I host this site using [Amazon Web Services](https://aws.amazon.com/) for about ~55c a month. I use [Route 53](https://aws.amazon.com/route53/) for DNS and [S3](https://aws.amazon.com/s3/) for hosting the content.

### Publish to S3

Ensure the [AWS CLI](https://aws.amazon.com/cli/) is installed.

```
aws s3 sync ./public s3://ryanloader.me --exclude *.DS_Store
```