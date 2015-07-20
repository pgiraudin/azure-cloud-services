Ruxit for Microsoft Azure Cloud-Services
========================================

Ruxit is a full-stack application monitoring solution that covers your entire application stack. Learn more on our website https://ruxit.com

Monitoring Azure Cloud-Services
-------------------------------

Azure Cloud-Services gives you the option of deploying and auto scaling applications and services.
You can use our predefined .csdef configuration file to modify the process of deployment by supplying additional resources. 

First, please copy the <LocalResources> and <Startup> tags from the ServiceDefinition.csdef file to the one of the CloudService solution. We're providing the whole .csdef file here as it might help you in finding out where those tags exactly belong.

ruxit_tenant
------------
Your ruxit tenant ID is the unique identifier of your ruxit environment. You can find it easily by looking at the URL in your browser when you are logged into your Ruxit home page.

https://{tenant}.live.ruxit.com

The subdomain {tenant} represents your tenant id.

ruxit_token
-----------
The token for your ruxit tenant. You can get your token by following these steps

go to your ruxit environment: https://{tenant}.live.ruxit.com
Click the burger menu in the right upper corner and select Monitor another host
You will see the "Download Ruxit Agent" wizard; click Linux (even if you need Windows)
You will see the wget command line. The token is the last part of the path after /latest/

wget -O ruxit-Agent-Linux-1.XX.0.2015XXXX-XXXXXX.sh https://{tenant}.live.ruxit.com/installer/agent/unix/latest/{this-is-the-token}

Copy it and use it in your config

Then, please copy the setupRuxit.cmd and Install.ps1 files into your WebRole project. Open the properties of those files then and make sure that "Build Action" is set to "Embedded Resource" and "Copy to output directory" is set to "Copy always".


CONTACT
-------

https://ruxit.com




