S3 Code Promotion Role
=========

This role allows for the FOLIO strip build to be deployed or promoted to an S3 Bucket.

Requirements
------------

1. Python awscli package
    * The Role checks to see if package installed 
    * If not installed will try to install package


Role Variables
--------------

    source: S3 bucket or local directory of stipes build. Default:  "s3://folio-snapshot"
    destination: S3 buket to promote code. Default: "s3://folio-snapshot-stable"

Optional Variables
------------
If environment does not have AWS Role permissions for build instance or AWS Role permissions assigned to Kubernetes node.  

    aws_access_key: AWS Access Key
    aws_secret_key: AWS Secret Key


Example Execution
----------------

1. Promtion of code from S3 Bucket (Default varibles)


        $ ansible localhost -m import_role -a name=s3-code-promotion


2. Promtion of code from S3 Bucket (Varibles from CLI)

        $ ansible localhost -m import_role \
            -e source=s3://my-source-bucket  \
            -e destination=s3://my-destination-bucket \
            -a name=s3-code-promotion

3. Promtion of code from local build directory (Varibles from CLI)

        $ ansible localhost -m import_role \
            -e source=/path/local-build  \
            -e destination=s3://my-destination-bucket \
            -a name=s3-code-promotion

4. Run Role within another Role

        - name: Code Promotion to S3 
          include_role:
            name: s3-code-promotion
          vars:
            source: << s3://bucket or local build location >>
            destination: s3://my-destination-bucket


Author Information
------------------

FOLIO
